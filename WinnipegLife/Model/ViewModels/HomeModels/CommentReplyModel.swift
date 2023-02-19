//
//  CommentReplyModel.swift
//  WinnipegLife
//
//  Created by changming wang on 7/2/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI

class CommentReplyModel: ObservableObject {
    
    let baseUrl = BaseUrl().url
    
    @Published var isLoading = false
    
    @Published var comments:[CommentsModel] = []
    
    @Published var noMoreData:Bool = false
    //回复的文字内容
    @Published var replyText:String = ""
    //回复的图片内容，自带一张用于点击的图片，此图片用来点击，点击后进入相册
    @Published var replyImages:[ReplyImage] = [ReplyImage(image: UIImage(named: "imageAddButton")!)]
    //显示回复窗口
    @Published var showSendCommentView:Bool = false
    //正在发送评论
    @Published var sendingReply:Bool = false

    
    private var pid:String
    
    private var mainThreadPid:String = ""
    
    private var pageNumber:Int = 1
    
    private var loadCount: Int = 0
    
    private var userInfos:[String:UserInfo] = [:]
    
    private var attachmentsInfos:[String:ImageAttachmentInfo] = [:]
    
    init(pid: String) {
        self.isLoading = true
        self.pid = pid
    }
    
    func fetchData(){
        
//        let url = "https://media.lifewpg.ca/api/posts?filter[reply]=" + self.pid + "&page[number]=" + String(self.pageNumber) + "&page[limit]=10&include=user,images"
        
        let url = baseUrl + "posts?filter[reply]=" + self.pid + "&page[number]=" + String(self.pageNumber) + "&page[limit]=10&include=user,images"
        
        self.pageNumber += 1
        
        AF.request(url).responseJSON {[weak self] response in
            
            guard let self = self else { return }
            
            switch response.result{
            
            case .success(let value):
                let json = JSON(value)
                let datas = json["data"].array!
                if datas.count > 0{
                    for data in datas{
                        var model = CommentsModel()
                        let attributes = data["attributes"].dictionary!
                        let pid = String((attributes["id"]?.int)!)
                        model.pid = pid
                        
                        let parseContentHtml = attributes["parseContentHtml"]?.stringValue
                        model.parseContentHtml = parseContentHtml!
                        
                        let createdAt = attributes["createdAt"]?.string ?? ""
                        model.createdAt = self.formatDate(dateStr: createdAt)
                        
                        let relationships = data["relationships"].dictionary!
                        let user = relationships["user"]?.dictionary!
                        let userData = user!["data"]?.dictionary!
                        let userId = userData!["id"]?.string!
                        
                        model.userId = userId!
                        
                        let images = relationships["images"]?.dictionary!
                        let imagesDatas = images!["data"]?.arrayValue
                        if imagesDatas!.count > 0{
                            for imageData in imagesDatas!{
                                let image = imageData.dictionary!
                                let id = image["id"]?.stringValue
                                model.attachmentsId.append(id!)
                            }
                        }
                        
                        self.comments.append(model)
                    }
                }else{
                    self.noMoreData = true
                    return
                }
                
                let included = json["included"].arrayValue
                
                for item in included{
                    let type = item["type"].stringValue
                    if type == "users"{
                        let id = item["id"].stringValue
                        let attr = item["attributes"].dictionaryValue
                        var userInfo = UserInfo()
                        userInfo.userName = attr["username"]!.stringValue
                        userInfo.userAvatar = attr["avatarUrl"]!.stringValue
                        self.userInfos[id] = userInfo
                    }else if type == "attachments"{
                        let id = item["id"].stringValue
                        let attr = item["attributes"].dictionaryValue
                        var attachment = ImageAttachmentInfo()
                        attachment.url = attr["url"]!.stringValue
                        attachment.thumbUrl = attr["thumbUrl"]!.stringValue
                        self.attachmentsInfos[id] = attachment
                        
                    }else if type == "threads"{
                        let id = item["id"].stringValue
                        
                        self.mainThreadPid = id
                    }
                    
                }

                for index in self.comments.indices{
                    self.comments[index].userInfo = self.userInfos[self.comments[index].userId]!
                }
                
                for index in self.comments.indices{

                    if self.comments[index].attachmentsId.count > 0 {
                        for id in self.comments[index].attachmentsId{
//                            print(self.attachmentsInfos[id]!)
                            self.comments[index].imageUrls.append(self.attachmentsInfos[id]!)
                        }
                    }

                }
                
                self.isLoading = false
                
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
    
    func fecthMore(){
        self.isLoading = true
        
//        let url = "https://media.lifewpg.ca/api/posts?filter[reply]=" + self.pid + "&page[number]=" + String(self.pageNumber) + "&page[limit]=10&include=user,images"
        
        let url = baseUrl + "posts?filter[reply]=" + self.pid + "&page[number]=" + String(self.pageNumber) + "&page[limit]=10&include=user,images"
        
        self.pageNumber += 1
        
        AF.request(url).responseJSON {[weak self] response in
            
            guard let self = self else { return }
            
            switch response.result{
            
            case .success(let value):
                let json = JSON(value)
                let datas = json["data"].array!
                if datas.count > 0{
                    for data in datas{
                        var model = CommentsModel()
                        let attributes = data["attributes"].dictionary!
                        let pid = String((attributes["id"]?.int)!)
                        model.pid = pid
                        
                        let parseContentHtml = attributes["parseContentHtml"]?.stringValue
                        model.parseContentHtml = parseContentHtml!
                        
                        let createdAt = attributes["createdAt"]?.string ?? ""
                        model.createdAt = self.formatDate(dateStr: createdAt)
                        
                        let relationships = data["relationships"].dictionary!
                        let user = relationships["user"]?.dictionary!
                        let userData = user!["data"]?.dictionary!
                        let userId = userData!["id"]?.string!
                        
                        model.userId = userId!
                        
                        let images = relationships["images"]?.dictionary!
                        let imagesDatas = images!["data"]?.arrayValue
                        if imagesDatas!.count > 0{
                            for imageData in imagesDatas!{
                                let image = imageData.dictionary!
                                let id = image["id"]?.stringValue
                                model.attachmentsId.append(id!)
                            }
                        }
                        
                        self.comments.append(model)
                    }
                    
                    let included = json["included"].arrayValue
                    
                    for item in included{
                        let type = item["type"].stringValue
                        if type == "users"{
                            let id = item["id"].stringValue
                            let attr = item["attributes"].dictionaryValue
                            var userInfo = UserInfo()
                            userInfo.userName = attr["username"]!.stringValue
                            userInfo.userAvatar = attr["avatarUrl"]!.stringValue
                            self.userInfos[id] = userInfo
                        }else if type == "attachments"{
                            let id = item["id"].stringValue
                            let attr = item["attributes"].dictionaryValue
                            var attachment = ImageAttachmentInfo()
                            attachment.url = attr["url"]!.stringValue
                            attachment.thumbUrl = attr["thumbUrl"]!.stringValue
                            self.attachmentsInfos[id] = attachment
                            
                        }
                    }

                    let startIndex = self.loadCount * 10
                    
                    for index in startIndex...self.comments.count - 1{
                        self.comments[index].userInfo = self.userInfos[self.comments[index].userId]!
                    }
                    
//                    for index in startIndex...self.comments.count - 1{
//
//                        if self.comments[index].attachmentsId.count > 0 {
//                            for id in self.comments[index].attachmentsId{
//    //                            print(self.attachmentsInfos[id]!)
//                                self.comments[index].imageUrls.append(self.attachmentsInfos[id]!)
//                            }
//                        }
//
//                    }
                    
                }else{
                    self.noMoreData = true
                }
                
                
            case .failure(let error):
                print(error)
                
            }
        }
        
        self.isLoading = false
    }
    
    func uploadReplyImage(_ image:ReplyImage){
        
        guard let user = UserManager.user else {
            return
        }
//
//        let url = "https://media.lifewpg.ca/api/attachments"
        
        let url = baseUrl + "attachments"
        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.authorization(bearerToken: user.accessToken),
            HTTPHeader.contentType("multipart/form-data"),
            HTTPHeader.contentDisposition("form-data")
        ])
        
        
        let index = self.getIndex(image: image)
        
        self.replyImages[index].status = .uploading
        
        var data = Data()
        let imageData = NSData(data: self.replyImages[index].image!.jpegData(compressionQuality: 1)!)
        let imageSize: Int = imageData.count
        // 图片大小大于5M时进行压缩
        if imageSize > (5 * 1000000){
            let compression = Double(5 * 1000000) / Double(imageSize)
            let resizeData = NSData(data: self.replyImages[index].image!.jpegData(compressionQuality: CGFloat(compression))!)
            data = Data(resizeData)
        }else{
            data = self.replyImages[index].image!.jpegData(compressionQuality: 1)!
        }
        
        let request = self.makeRequest(url: url, image: data, headers: headers)
        
        request.responseJSON{ [weak self] response in
            
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
//                print(value)
                let datas = JSON(value)
                let data = datas["data"].dictionaryValue
                let id = data["id"]?.stringValue
                let index = self.getIndex(image: image)
                self.replyImages[index].attachmentId = id!
                self.replyImages[index].status = .uploaded
            
                
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
    
    func sendReply(replyPid: String) {
        
        guard let user = UserManager.user else {
            return
        }
        
        self.sendingReply = true
        
//        let url = "https://media.lifewpg.ca/api/posts"
        
        let url = baseUrl + "posts"
        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.authorization(bearerToken: user.accessToken)
        ])
        
        var replyData = ReplyDataClass()
        var replyRelationships = ReplyRelationships()
        var replyAttributes = ReplyAttributes()
        
        replyRelationships.thread = ReplyThread(data: ReplyDAT(id: self.mainThreadPid, type: "threads"))
        
        replyAttributes.content = self.replyText
            
        if self.replyImages.count > 1 {
            
            var replyAttachments = ReplyAttachments()
            
            replyAttachments.data = []
            for index in 0..<self.replyImages.count - 1 {
                
                guard let imageId = self.replyImages[index].attachmentId else { return }
                
                var replyImage = ReplyDAT()
                
                replyImage.id = imageId
                replyImage.type = "attachments"
                
                replyAttachments.data?.append(replyImage)
            }
            
            replyRelationships.attachments = replyAttachments

        }
        

        replyAttributes.isComment = true
        replyAttributes.replyID = self.pid

        
        replyData.relationships = replyRelationships
        replyData.attributes = replyAttributes
        
        let reply = ReplyModel(data: replyData)
        
//        print(reply.data?.relationships?.attachments)
        let request = makeReplyRequest(url: url, parameters: reply, headers: headers)

        request.responseJSON{ [weak self] response in

            guard let self = self else { return }

            switch response.result{
            case .success(let value):
                print(value)
                
                if self.noMoreData {
                    let json = JSON(value)
                    let data = json["data"].dictionaryValue
                    
                    var model = CommentsModel()
                    let attributes = data["attributes"]?.dictionary!
                    let pid = String((attributes!["id"]?.int)!)
                    model.pid = pid
                    
                    //加载评论内容
                    let parseContentHtml = attributes!["parseContentHtml"]?.stringValue
                    model.parseContentHtml = parseContentHtml!
                    //加载评论创建时间
                    let createdAt = attributes!["createdAt"]?.string ?? ""
                    model.createdAt = self.formatDate(dateStr: createdAt)
                    //加载其他评论这条评论的数量
                    let replyCount = attributes!["replyCount"]?.intValue
                    model.repliesCount = replyCount!
                    //获取发布用户id
                    let relationships = data["relationships"]!.dictionary!
                    let user = relationships["user"]?.dictionary!
                    let userData = user!["data"]?.dictionary!
                    let userId = userData!["id"]?.string!
                    model.userId = userId!
                    
                    //获取评论图片信息
                    let images = relationships["images"]?.dictionary!
                    let imagesDatas = images!["data"]?.arrayValue
                    if imagesDatas!.count > 0{
                        for imageData in imagesDatas!{
                            let image = imageData.dictionary!
                            let id = image["id"]?.stringValue
                            model.attachmentsId.append(id!)
                        }
                    }
                    
                    
                    let included = json["included"].arrayValue
                    
                    for item in included{
                        let type = item["type"].stringValue
                        if type == "users"{
                            let id = item["id"].stringValue
                            let attr = item["attributes"].dictionaryValue
                            var userInfo = UserInfo()
                            userInfo.userName = attr["username"]!.stringValue
                            userInfo.userAvatar = attr["avatarUrl"]!.stringValue
                            self.userInfos[id] = userInfo
                            model.userInfo = userInfo
                        }else if type == "attachments"{
                            let id = item["id"].stringValue
                            let attr = item["attributes"].dictionaryValue
                            var attachment = ImageAttachmentInfo()
                            attachment.url = attr["url"]!.stringValue
                            attachment.thumbUrl = attr["thumbUrl"]!.stringValue
                            self.attachmentsInfos[id] = attachment
                            model.imageUrls.append(attachment)
                        }
                    }
                    
                    self.comments.append(model)
                }
                
                self.showSendCommentView = false
                self.cleanReplyData()
                self.sendingReply = false
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
    
    func cleanReplyData() {
        
        self.replyText = ""
        
        self.replyImages.removeSubrange(0..<self.replyImages.count - 1)
    }

    func isUploadingImages() -> Bool {
        var result:Bool = false
        
        if self.replyImages.count > 1{
            for index in 0..<self.replyImages.count - 1{
                if self.replyImages[index].status != .uploaded{
                    result = true
                }
            }
        }

        return result
    }
    
    private func makeRequest(url: String,image: Data, headers: HTTPHeaders) -> DataRequest {
        
        return AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image, withName: "file", fileName: "file", mimeType: "image/jpeg")
            let type: Int = 1
            multipartFormData.append("\(type)".data(using: .utf8)!, withName: "type")
            
        }, to: URL.init(string: url)!,
        method: .post,
        headers: headers)
    }
    
    func makeReplyRequest(url:String, parameters: ReplyModel, headers: HTTPHeaders) -> DataRequest {
        
//        print(parameters)
        
        return AF.request(url, method: .post, parameters: parameters,encoder: JSONParameterEncoder.default,headers: headers){ request in
            request.timeoutInterval = 5
        }
    }
    
    private func getIndex(image: ReplyImage) -> Int {
        return self.replyImages.firstIndex { (image1) -> Bool in
            return image.id == image1.id
        } ?? 0
    }
    
    private func formatDate(dateStr:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm"
        
        var result = ""
        if let date = dateFormatterGet.date(from: dateStr) {
            result = dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
        }
        
        return result
    }
    
}
