//
//  PostThreadModel.swift
//  WinnipegLife
//
//  Created by changming wang on 8/9/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI

class PostThread:ObservableObject{
    
    let baseUrl = BaseUrl().url
    
    //    @Published var title:String = ""
    @Published var loadingCateegoriesList:Bool = false
    //发布内容
    @Published var content:String = ""
    //发布图片
    @Published var postImages:[PostImage] = []
    // 用于展示分类选择的列表
    @Published var pickerList:[String] = []
    // 目前是选择第一级目录，还是第二级目录， true 代表第一级目录
    @Published var firstOrSecond: Bool = true
    // 第一级目录列表
    @Published var firstCategoryList:[String] = []
    // 第二级目录列表（可选）
    @Published var sencondCategoryList:[String] = []
    // 第一级目录选择的index
    @Published var firstCategoryIdSelected:Int = -1
    // 第二级目录选择的index（可选）
    @Published var secondCategoryIdSelected:Int = -1
    
    // 用于显示选择目录
    @Published var showPicker:Bool = false
    // 存储目录信息
    @Published var categoryInfos:[String:CategoryInfo] = [:]
    // 正在发送帖子
    @Published var sendingThread:Bool = false
    // 帖子发送完毕，主要用于发布完退出界面
    @Published var sendingDone:Bool = false
    
    //警告
    // 内容为空
    @Published var contentEmptyAlert:Bool = false
    // 还在上传图片
    @Published var uploadingAlert:Bool = false
    // 等待目前图片上传完成
    @Published var waitUploadingAlert:Bool = false
    // 一级目录不能为空
    @Published var categoryFirstAlert:Bool = false
    // 二级目录不能为空
    @Published var categorySecondAlert:Bool = false
    
    
    func fetchCategories(){
        
        /*
         这个函数用于拉取用户的目录，因为用户所在的群组不同，所以每个用户可拉取的目录不同
         */
        guard let user = UserManager.user else {
            return
        }
        
//        let url = "https://media.lifewpg.ca/api/categories"
        
        let url = baseUrl + "categories"
        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.authorization(bearerToken: user.accessToken)
        ])
        
        let request = makeCategoryRequest(url: url, headers: headers)
        
        request.responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let datas = json["data"].arrayValue
                
                for data in datas{
                    
                    let name = data["attributes"]["name"].string!
                    
                    if !name.hasPrefix("Xz"){
                        var cate = CategoryInfo()
                        
                        let id = data["id"].string!
                        self.firstCategoryList.append(name)
                        cate.searchId = id
                        
                        let children = data["attributes"]["children"].arrayValue
                        if children.count > 0 {
                            let result = self.getChildrenIDs(children: children)
                            
                            cate.childList = result.0
                            cate.childIds = result.1
                        }
                        self.categoryInfos[name] = cate
                        
                    }
                    
                }
                //                print(self.categoryInfos)
                
                self.loadingCateegoriesList = true
                
            case .failure(let error):
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .timedOut:
                            print("timeout")
                        case .notConnectedToInternet:
                            print("no internet")
                        default:
                            print("unknown")
                            
                        }
                    }
                }
            }
        }
    }
    
    
    func uploadReplyImage(_ image:PostImage){
        
        guard let user = UserManager.user else {
            return
        }
        
//        let url = "https://media.lifewpg.ca/api/attachments"
        
        let url = baseUrl + "attachments"
        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.authorization(bearerToken: user.accessToken),
            HTTPHeader.contentType("multipart/form-data"),
            HTTPHeader.contentDisposition("form-data")
        ])
        
        
        let index = self.getIndex(image: image)
        
        self.postImages[index].status = .uploading
        
        var data = Data()
        let imageData = NSData(data: self.postImages[index].image!.jpegData(compressionQuality: 1)!)
        let imageSize: Int = imageData.count
        // 图片大小大于5M时进行压缩
        if imageSize > (5 * 1000000){
            let compression = Double(5 * 1000000) / Double(imageSize)
            let resizeData = NSData(data: self.postImages[index].image!.jpegData(compressionQuality: CGFloat(compression))!)
            data = Data(resizeData)
        }else{
            data = self.postImages[index].image!.jpegData(compressionQuality: 1)!
        }
        
        let request = self.makeUploadingImageRequest(url: url, image: data, headers: headers)
        
        request.responseJSON{ [weak self] response in
            
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
                //                print(value)
                let datas = JSON(value)
                let data = datas["data"].dictionaryValue
                let id = data["id"]?.stringValue
                let index = self.getIndex(image: image)
                self.postImages[index].attachmentId = id!
                self.postImages[index].status = .uploaded
                
                
            case .failure(let error):
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .timedOut:
                            print("timeout")
                        case .notConnectedToInternet:
                            print("no internet")
                        default:
                            print("unknown")
                            
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    func sendThread(){
        
        guard let user = UserManager.user else {
            return
        }
        
        self.sendingThread = true
        
//        let url = "https://media.lifewpg.ca/api/threads"
        
        let url = baseUrl + "threads"
        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.authorization(bearerToken: user.accessToken)
        ])
        
        var id:String = ""
        if self.secondCategoryIdSelected == -1 {
            id = self.categoryInfos[self.firstCategoryList[self.firstCategoryIdSelected]]!.searchId
        }else{
            let firstCate = self.categoryInfos[self.firstCategoryList[self.firstCategoryIdSelected]]!
            let name = firstCate.childList![self.secondCategoryIdSelected]
            id = firstCate.childIds![name]!
            
        }
        
        var threadData = PostThreadModelData()
        var threadRelationships = PostThreadRelationships()
        var threadAttributes = PostThreadAttributes()
        
        threadRelationships.category = PostThreadCategory(data: PostThreadCategoryData(type: "categories", id: Int(id)))
    
        
        if self.postImages.count > 0 {
            
            threadAttributes.type = "3"
            var postAttachments = PostThreadAttachments()
            
            postAttachments.data = []
            for index in 0..<self.postImages.count {
                
                guard let imageId = self.postImages[index].attachmentId else { return }
                
                var postImage = Datum()
                
                postImage.id = imageId
                postImage.type = "attachments"
                
                postAttachments.data?.append(postImage)
            }
            
            threadRelationships.attachments = postAttachments

        }else{
            threadAttributes.type = "0"
        }
        
        threadAttributes.content = self.content
        
        
        threadData.relationships = threadRelationships
        threadData.attributes = threadAttributes
        
        let thread = PostThreadModel(data: threadData)
        
        let request = self.makeThreadRequest(url: url, parameters: thread, headers: headers)
        
        request.responseJSON { response in
            switch response.result{
            case .success(let value):
                print(value)
                self.sendingDone = true
                self.sendingThread = false
            case .failure(let error):
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .timedOut:
                            print("timeout")
                        case .notConnectedToInternet:
                            print("no internet")
                        default:
                            print("unknown")
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func checkImageStatus() -> Bool {
        
        var result:Bool = true
        
        if postImages.count > 0 {
            for image in self.postImages{
                if image.status != .uploaded{
                    result = false
                    break
                }
            }
        }
        
        return result
    }
    
    func checkCategorySelection() -> Bool{
        
        var result = true
        
        if self.firstCategoryIdSelected == -1 {
            self.categoryFirstAlert = true
            result = false
        }else{
            if self.secondCategoryIdSelected == -1 {
                self.categorySecondAlert = true
                result = false
            }
        }
        
        return result
    }
    
    
    private func getIndex(image: PostImage) -> Int {
        return self.postImages.firstIndex { (image1) -> Bool in
            return image.id == image1.id
        } ?? 0
    }
    
    private func makeCategoryRequest(url:String,headers: HTTPHeaders) -> DataRequest {
        
        //        print(parameters)
        
        return AF.request(url, method: .get,headers: headers){ request in
            request.timeoutInterval = 5
        }
    }
    
    private func makeUploadingImageRequest(url: String,image: Data, headers: HTTPHeaders) -> DataRequest {
        
        return AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image, withName: "file", fileName: "file", mimeType: "image/jpeg")
            let type: Int = 1
            multipartFormData.append("\(type)".data(using: .utf8)!, withName: "type")
            
        }, to: URL.init(string: url)!,
        method: .post,
        headers: headers)
    }
    
    private func makeThreadRequest(url:String, parameters: PostThreadModel, headers: HTTPHeaders) -> DataRequest {
        
        
        return AF.request(url, method: .post, parameters: parameters,encoder: JSONParameterEncoder.default,headers: headers){ request in
            request.timeoutInterval = 5
        }
    }
    
    private func getChildrenIDs(children: Array<JSON>) -> ([String],[String:String]){
        var names:[String] = []
        //        var ids:[String] = []
        
        var childrenDict:[String:String] = [:]
        
        for child in children{
            let id = String(child["id"].int!)
            let name = child["name"].string!
            //            self.categoryIds[name] = id
            //            ids.append(id)
            names.append(name)
            childrenDict[name] = id
        }
        
        return (names, childrenDict)
    }
    
}

struct PostImage:Identifiable {
    
    var id = UUID()
    var image: UIImage?
    var attachmentId: String?
    var status:ImageStatus = .waitingForUpload
    
    enum ImageStatus {
        case waitingForUpload
        case uploading
        case uploaded
    }
}

struct CategoryInfo:Identifiable {
    var id = UUID()
    var searchId: String = ""
    var childIds: [String:String]?
    var childList:[String]?
}
