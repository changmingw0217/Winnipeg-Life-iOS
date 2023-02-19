//
//  CommunityDetailModel.swift
//  WinnipegLife
//
//  Created by changming wang on 7/1/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSoup
import PhoneNumberKit
import SwiftUI

class DetailCommunityViewModel: ObservableObject, Identifiable{
    
    let baseUrl = BaseUrl().url
    
    var id = UUID()
    
    //帖子是否加载完成
    @Published var loaded:Bool = false
    //用于存储帖子的各种信息
    @Published var viewContent: ViewModel = ViewModel()
    //用于标记帖子正文中图片的位置
    @Published var contentImageIndex:[Int] = []
    //存储评论模型
    @Published var comments:[CommentsModel] = []
    //用于加载更多评论
    @Published var loadingComments:Bool = false
    //没有更多评论
    @Published var noMoreData:Bool = false
    //回复的文字内容
    @Published var replyText:String = ""
    //回复的图片内容，自带一张用于点击的图片，此图片用来点击，点击后进入相册
    @Published var replyImages:[ReplyImage] = [ReplyImage(image: UIImage(named: "imageAddButton")!)]
    //显示回复窗口
    @Published var showSendCommentView:Bool = false
    //正在发送评论
    @Published var sendingReply:Bool = false
    //帖子在服务器上的id
    private var pid:String
    //更多评论的页码
    private var pageNumber: Int = 1
    //使用这个来不更新已经加载过的评论
    private var loadCount: Int = 0
    
    private var categortDict:[String:String] = CategoryDict.getCategoryDict()!.dict!
    
    private var userInfos:[String:UserInfo] = [:]
    
    private var attachmentsInfos:[String:ImageAttachmentInfo] = [:]
    //防止出现加载两次的错误
    private var contentLoading:Bool = false
    
    
    // 这两个用于初始化的时候加载内容，回复，以及回复的回复数量
    private var contentLoaded:Bool = false{
        didSet{
            loaded = contentLoaded && commentLoaded
        }
    }
    
    private var commentLoaded:Bool = false{
        didSet{
            loaded = contentLoaded && commentLoaded
        }
    }
    
    
    init(pid: String) {
        
        self.pid = pid
        //        self.requestData()
        //        print("\(self.pid) init")
    }
    
    func fetchData() {
        //        print(categortDict)
        
        if self.contentLoading {
            print("\(self.pid) 已加载")
            return
        }
        
        print("\(self.pid) load data")
        
        contentLoading = true
        
//        let url = "https://media.lifewpg.ca/api/mthreads/" + self.pid
        
        let url = baseUrl + "mthreads/" + self.pid
        
        AF.request(url).responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let attributes = json["data"]["attributes"].dictionary!
                
                let viewCount = String(attributes["viewCount"]?.int ?? 0)
                self.viewContent.viewCount = viewCount
                
                let postCount = String(attributes["postCount"]?.int ?? 0)
                self.viewContent.postCount = postCount
                
                let title = attributes["title"]?.string ?? ""
                self.viewContent.viewTitle = title
                
                let createdAt = attributes["createdAt"]?.string ?? ""
                self.viewContent.createdAt = self.formatDate(dateStr: createdAt)
                
                let storeName = attributes["storeName"]?.string ?? ""
                self.viewContent.storeName = storeName
                
                let storePhone = attributes["storePhone"]?.string ?? ""
                self.viewContent.storePhone = storePhone
                self.viewContent.formattedPhone = PartialFormatter().formatPartial(storePhone)
                
                let storeAddress = attributes["storeAddress"]?.string ?? ""
                self.viewContent.storeAddress = storeAddress
                
                let storeVideoId = attributes["storeVideoId"]?.string ?? ""
                self.viewContent.storeVideoId = self.videoID(id: storeVideoId)
                
                let included = json["included"][0].dictionary!
                do {
                    let doc: Document = try SwiftSoup.parse(included["attributes"]!["contentHtml"].string!)
                    let srcs: Elements = try doc.select("img[src]")
                    let srcsStringArray: [String?] = srcs.array().map { try? $0.attr("src").description }
                    guard let elements = try? doc.getAllElements() else { return }
                    var srcIndex = 0
                    for element in elements {
                        let tag = element.tagName()
                        
                        if tag == "p"{
                            self.viewContent.htmlContent.append(["p": try element.text()])
                            self.contentImageIndex.append(-1)
                        }
                        if tag == "img"{
                            self.viewContent.htmlContent.append(["img": srcsStringArray[srcIndex]!])
                            self.viewContent.contentImageUrls.append(srcsStringArray[srcIndex]!)
                            self.contentImageIndex.append(srcIndex)
                            srcIndex += 1
                        }
                    }
                    
                    
                } catch Exception.Error( _, let message) {
                    print(message)
                } catch {
                    print("error")
                }
                
                
                let attachments = json["included"].arrayValue
                if attachments.count >= 2{
                    for attachment in attachments{
                        let item = attachment.dictionary!
                        let type = item["type"]?.string
                        if type == "attachments"{
                            let attr = item["attributes"]?.dictionary!
                            let fileType = attr?["fileType"]?.string ?? ""
                            if self.checkAttachmentFileType(file: fileType) == "image"{
                                let url = attr?["url"]?.string ?? ""
                                if url != ""{
                                    self.viewContent.attachmentsImageUrls.append(url)
                                }
                                
                                let thumbUrl = attr?["thumbUrl"]?.string ?? ""
                                
                                if thumbUrl != "" {
                                    self.viewContent.attachmentsImageThumbUrls.append(thumbUrl)
                                }
                            }
                            
                        }else if type == "users"{
                            let attr = item["attributes"]?.dictionary!
                            self.viewContent.userName = attr?["username"]?.string ?? ""
                            self.viewContent.userAvatar = attr?["avatarUrl"]?.string ?? ""
                            self.viewContent.userId = String(attr?["id"]?.int ?? 0)
                        }else{
                            continue
                        }
                    }
                }
                self.contentLoaded = true
                
                
                self.fetchComments()
                
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
    
    private func fetchComments(){
        
//        let url = "https://media.lifewpg.ca/api/posts?filter[isDeleted]=no&filter[isComment]=no&page[number]=" + String(self.pageNumber
//        ) + "&page[limit]=10&filter[thread]=" + self.pid + "&include=user,images"
        
        let url = baseUrl + "posts?filter[isDeleted]=no&filter[isComment]=no&page[number]=" + String(self.pageNumber
        ) + "&page[limit]=10&filter[thread]=" + self.pid + "&include=user,images"
        
        self.pageNumber += 1
        
        
        AF.request(url).responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let datas = json["data"].array!
                
                for data in datas{
                    var model = CommentsModel()
                    let attributes = data["attributes"].dictionary!
                    let pid = String((attributes["id"]?.int)!)
                    model.pid = pid
                    
                    //加载评论内容
                    let parseContentHtml = attributes["parseContentHtml"]?.stringValue
                    model.parseContentHtml = parseContentHtml!
                    //加载评论创建时间
                    let createdAt = attributes["createdAt"]?.string ?? ""
                    model.createdAt = self.formatDate(dateStr: createdAt)
                    //获取发布用户id
                    let relationships = data["relationships"].dictionary!
                    let user = relationships["user"]?.dictionary!
                    let userData = user!["data"]?.dictionary!
                    let userId = userData!["id"]?.string!
                    model.userId = userId!
                    
                    //加载其他评论这条评论的数量
                    let replyCount = attributes["replyCount"]?.intValue
                    model.repliesCount = replyCount!
                    
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
                    //                    print(model.attachmentsId)
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
                
                
                //加载一共有多少条评论
                let meta = json["meta"].dictionaryValue
                
                self.viewContent.commentCount = meta["postCount"]!.intValue
                
                //这里加载每条评论的用户信息
                for index in self.comments.indices{
                    
                    self.comments[index].userInfo = self.userInfos[self.comments[index].userId]!
                    
                    if index == self.comments.count - 1{
                        self.commentLoaded = true
                    }
                    
                }
                
                
                //这里加载每条图片的图片信息
                for index in self.comments.indices{
                    
                    if self.comments[index].attachmentsId.count > 0 {
                        for id in self.comments[index].attachmentsId{
                            //                            print(self.attachmentsInfos[id]!)
                            self.comments[index].imageUrls.append(self.attachmentsInfos[id]!)
                        }
                    }
                    
                }
                
                self.commentLoaded = true
            case .failure(let error):
                print(error)
            }
        }
        
        //        self.commentLoaded = true
    }
    
    func fetchMoreComments(){
        
        self.loadingComments = true
        
//        let url = "https://media.lifewpg.ca/api/posts?filter[isDeleted]=no&filter[isComment]=no&page[number]=" + String(self.pageNumber
//        ) + "&page[limit]=10&filter[thread]=" + self.pid + "&include=user,images"
        
        let url = baseUrl + "posts?filter[isDeleted]=no&filter[isComment]=no&page[number]=" + String(self.pageNumber
        ) + "&page[limit]=10&filter[thread]=" + self.pid + "&include=user,images"
        
        self.pageNumber += 1
        self.loadCount += 1
        
        AF.request(url).responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let datas = json["data"].array!
                
                if datas.count > 0 {
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
                        
                        //加载其他评论这条评论的数量
                        let replyCount = attributes["replyCount"]?.intValue
                        model.repliesCount = replyCount!
                        
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

                        if index == self.comments.count - 1 {
                            self.loadingComments = false
                        }
                    }
                    
                    for index in startIndex...self.comments.count - 1{
                        
                        if self.comments[index].attachmentsId.count > 0 {
                            for id in self.comments[index].attachmentsId{
                                //                            print(self.attachmentsInfos[id]!)
                                self.comments[index].imageUrls.append(self.attachmentsInfos[id]!)
                            }
                        }
                        
                    }
                    
                }else{
                    self.noMoreData = true
                }
                
                self.loadingComments = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func uploadReplyImage(_ image:ReplyImage){
        
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
    
    func sendReply(isComment: Bool? = nil, replyPid: String? = nil) {
        
        guard let user = UserManager.user else {
            return
        }
        
        self.sendingReply = true
        
        self.showSendCommentView = false
        
        let url = baseUrl + "posts"
        
//        let url = "https://media.lifewpg.ca/api/posts"
        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.authorization(bearerToken: user.accessToken)
        ])
        
        var replyData = ReplyDataClass()
        var replyRelationships = ReplyRelationships()
        var replyAttributes = ReplyAttributes()
        
        replyRelationships.thread = ReplyThread(data: ReplyDAT(id: self.pid, type: "threads"))
        
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
        
        if isComment != nil{
            replyAttributes.isComment = true
            replyAttributes.replyID = replyPid
        }
        
        replyData.relationships = replyRelationships
        replyData.attributes = replyAttributes
        
        let reply = ReplyModel(data: replyData)
        
//        print(reply.data?.relationships?.attachments)
        let request = makeReplyRequest(url: url, parameters: reply, headers: headers)

        request.responseJSON{ [weak self] response in

            guard let self = self else { return }

            switch response.result{
            case .success(let value):
                
//                print(value)
                
                if isComment != nil{
                    let index = self.getCommentIndex(pid: replyPid!)
                    
                    self.comments[index].repliesCount += 1
                    
                }else{
                    if self.noMoreData || self.comments.count == 0 {
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
                        self.viewContent.commentCount += 1
                    }
                }
                
                
                self.sendingReply = false
                self.cleanReplyData()

                
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
    
    
    private func getIndex(image: ReplyImage) -> Int {
        return self.replyImages.firstIndex { (image1) -> Bool in
            return image.id == image1.id
        } ?? 0
    }
    
    private func getCommentIndex(pid: String) -> Int {
        var result = 0
        for index in 0..<self.comments.count {
            if self.comments[index].pid == pid{
                result = index
                break
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
    

    private func videoID(id:String) -> String{
        if id.count == 11 {
            return id
        }else{
            return ""
        }
    }
    
    private func checkAttachmentFileType(file:String) -> String{
        return file.components(separatedBy: "/")[0]
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


struct CommentsModel:Identifiable {
    var id = UUID()
    var pid:String = ""
    var userId:String = ""
    var userInfo:UserInfo = UserInfo()
    var htmlContent:[[String: String]] = []
    var createdAt:String = ""
    var repliesCount:Int = 0
    var parseContentHtml:String = ""
    var attachmentsId:[String] = []
    var imageUrls:[ImageAttachmentInfo] = []
    
}

struct UserInfo:Identifiable {
    var id = UUID()
    var userName:String = ""
    var userAvatar:String = ""
}

struct ImageAttachmentInfo:Identifiable {
    var id = UUID()
    var url:String = ""
    var thumbUrl:String = ""
}

struct ReplyImage:Identifiable {
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



