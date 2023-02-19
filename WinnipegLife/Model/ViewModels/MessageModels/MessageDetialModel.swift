//
//  MessageDetialModel.swift
//  WinnipegLife
//
//  Created by changming wang on 7/13/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageDetail: ObservableObject{
    
    let baseUrl = BaseUrl().url
    
    @Published var initDone:Bool = false
    
    @Published var fetchingNew:Bool = false
    
    @Published var fetchingOld:Bool = false
    
    @Published var noMore:Bool = false
    
    @Published var chatHistory:[DetailMessage] = []
    
    @Published var newMessageIndicator:Int = 0
    
    private let dialogId:String
    
    private var pageNumber:Int = 1
    
    //用于储存对方用户的信息
    private var member:Member = Member()
    
    init(chatId:String) {
        self.dialogId = chatId
        self.initMessage()
    }
    
    private func initMessage(){
        
        if let user = UserManager.user{
            
//            let url = "https://media.lifewpg.ca/api/dialog/message?filter[dialog_id]=" + dialogId + "&include=user&page[number]=" + String(pageNumber) + "&page[limit]=10&sort=-createdAt"
            
            let url = baseUrl + "dialog/message?filter[dialog_id]=" + dialogId + "&include=user&page[number]=" + String(pageNumber) + "&page[limit]=10&sort=-createdAt"
            
            self.pageNumber += 1
//            print(url)

            let headers : HTTPHeaders = HTTPHeaders.init([

                HTTPHeader.authorization(bearerToken: user.accessToken)
            ])
            
            let request = AF.request(url, headers: headers)
            
            request.responseJSON{ [weak self] response in
                guard let self = self else { return }
                
                switch response.result{
                case .success(let value):
                    let datas = JSON(value)
                    let dataList = datas["data"].arrayValue
                    let included = datas["included"].arrayValue
                    
                    if dataList.count < 10 {
                        self.noMore = true
                    }

                    for data in dataList{
                        var message = DetailMessage()
                        let attributes = data["attributes"].dictionaryValue
                        let userID = String(attributes["user_id"]!.intValue)
                        //消息是不是登录账号发的
                        message.isMe = userID == user.id ? true : false
                        //消息内容
                        let summary = attributes["summary"]!.stringValue
                        message.text = summary
                        //消息发送时间
                        let createdAt = attributes["created_at"]!.stringValue
                        message.createdAt = self.formatDate(dateStr: createdAt)
                        
                        self.chatHistory.insert(message, at: 0)
                    }
                    
                    for include in included{
                        let type = include["type"].stringValue
                        let id = include["id"].stringValue
                        
                        if type == "users"{
                            if id != user.id{
                                let attr = include["attributes"].dictionaryValue
                                let username = attr["username"]!.stringValue
                                let avatar = attr["avatarUrl"]!.stringValue
                                
                                self.member.name = username
                                
                                self.member.icon = avatar
                            }
                        }
                    }
                    
                    for index in self.chatHistory.indices {
                        if self.chatHistory[index].isMe{
                            self.chatHistory[index].member.name = user.username
                            self.chatHistory[index].member.icon = user.avatarUrl
                        }else{
                            self.chatHistory[index].member = self.member
                        }
                    }
                    
                    self.initDone = true
//                    print(self.chatHistory)
                    
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
    }
    
    func fetchOldMessage(){
        
        if let user = UserManager.user{
            
//            let url = "https://media.lifewpg.ca/api/dialog/message?filter[dialog_id]=" + dialogId + "&include=user&page[number]=" + String(pageNumber) + "&page[limit]=10&sort=-createdAt"
            
            let url = baseUrl + "dialog/message?filter[dialog_id]=" + dialogId + "&include=user&page[number]=" + String(pageNumber) + "&page[limit]=10&sort=-createdAt"
            
            fetchingOld = true
            
//            print(url)
            self.pageNumber += 1

            let headers : HTTPHeaders = HTTPHeaders.init([

                HTTPHeader.authorization(bearerToken: user.accessToken)
            ])
            
            let request = AF.request(url, headers: headers)
            
            request.responseJSON{ [weak self] response in
                guard let self = self else { return }
                
                switch response.result{
                case .success(let value):
                    let datas = JSON(value)
                    let dataList = datas["data"].arrayValue
                    let included = datas["included"].arrayValue
                    
                    if dataList.count > 0 {
                        
                        var oldChatHistory:[DetailMessage] = []
                        
                        for data in dataList{
                            var message = DetailMessage()
                            let attributes = data["attributes"].dictionaryValue
                            let userID = String(attributes["user_id"]!.intValue)
                            //消息是不是登录账号发的
                            message.isMe = userID == user.id ? true : false
                            //消息内容
                            let summary = attributes["summary"]!.stringValue
                            message.text = summary
                            //消息发送时间
                            let createdAt = attributes["created_at"]!.stringValue
                            message.createdAt = self.formatDate(dateStr: createdAt)
                            
                            oldChatHistory.append(message)
                        }
                        
                        for include in included{
                            let type = include["type"].stringValue
                            let id = include["id"].stringValue
                            
                            if type == "users"{
                                if id != user.id{
                                    let attr = include["attributes"].dictionaryValue
                                    let username = attr["username"]!.stringValue
                                    let avatar = attr["avatarUrl"]!.stringValue
                                    
                                    self.member.name = username
                                    
                                    self.member.icon = avatar
                                }
                            }
                        }
                        
                        for index in oldChatHistory.indices {
                            if oldChatHistory[index].isMe{
                                oldChatHistory[index].member.name = user.username
                                oldChatHistory[index].member.icon = user.avatarUrl
                            }else{
                                oldChatHistory[index].member = self.member
                            }
                        }
                        
                        for index in oldChatHistory.indices {
                            self.chatHistory.insert(oldChatHistory[index], at: 0)
                        }
                         
                        
//                        print(oldChatHistory)
                        
                    }else{
                        self.noMore = true
                    }
                                        
                    self.fetchingOld = false
                    
//                    print(self.chatHistory)
                    
                case .failure(let error):
                    if let underlyingError = error.underlyingError {
                        if let urlError = underlyingError as? URLError {
                            switch urlError.code {
                            case .timedOut:
                                self.fetchingOld = false
                                print("timeout")
                            case .notConnectedToInternet:
                                self.fetchingOld = false
                                print("no internet")
                            default:
                                self.fetchingOld = false
                                print("unknown")
                                
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    func fetchNewMessage() {
        
//        let now = Date()
//        print("获取新的message + \(now)")
        
        self.fetchingNew = true
        
        if let user = UserManager.user{
            
//            let url = "https://media.lifewpg.ca/api/dialog/message?filter[dialog_id]=" + dialogId + "&include=user&page[number]=1&page[limit]=10&sort=-createdAt"
            
            let url = baseUrl + "dialog/message?filter[dialog_id]=" + dialogId + "&include=user&page[number]=1&page[limit]=10&sort=-createdAt"
            //            print(url)

            let headers : HTTPHeaders = HTTPHeaders.init([

                HTTPHeader.authorization(bearerToken: user.accessToken)
            ])
            
            var newChatHistory:[DetailMessage] = []
            
            
            let request = AF.request(url, headers: headers)
            
            request.responseJSON{ [weak self] response in
                guard let self = self else { return }
                
                switch response.result{
                case .success(let value):
                    let datas = JSON(value)
                    let dataList = datas["data"].arrayValue
                    let included = datas["included"].arrayValue

                    
                    for data in dataList{
                        var message = DetailMessage()
                        let attributes = data["attributes"].dictionaryValue
                        let userID = String(attributes["user_id"]!.intValue)
                        //消息是不是登录账号发的
                        message.isMe = userID == user.id ? true : false
                        //消息内容
                        let summary = attributes["summary"]!.stringValue
                        message.text = summary
                        //消息发送时间
                        let createdAt = attributes["created_at"]!.stringValue
                        message.createdAt = self.formatDate(dateStr: createdAt)

//                        print(self.isNewMessage(msg: message))
                        if self.isNewMessage(msg: message){
                            newChatHistory.append(message)
                        }else{
                            break
                        }
                        
                    }
//
                    for include in included{
                        let type = include["type"].stringValue
                        let id = include["id"].stringValue

                        if type == "users"{
                            if id != user.id{
                                let attr = include["attributes"].dictionaryValue
                                let username = attr["username"]!.stringValue
                                let avatar = attr["avatarUrl"]!.stringValue

                                self.member.name = username

                                self.member.icon = avatar
                            }
                        }
                    }
                
                    for index in newChatHistory.indices {
                        if newChatHistory[index].isMe{
                            newChatHistory[index].member.name = user.username
                            newChatHistory[index].member.icon = user.avatarUrl
                        }else{
                            newChatHistory[index].member = self.member
                        }
                    }
                    
                    newChatHistory = newChatHistory.reversed()
                    
                    for history in newChatHistory{
                        self.chatHistory.append(history)
                        self.newMessageIndicator += 1
                    }
                    
                    self.fetchingNew = false
                                        
//                    print(self.chatHistory)
                    
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
    }
    
    func sendMessage(_ msg:String) {
        
        guard let user = UserManager.user else { return }
        
//        let url = "https://media.lifewpg.ca/api/dialog/message"
        
        let url = baseUrl + "dialog/message"
        
        let headers : HTTPHeaders = HTTPHeaders.init([

            HTTPHeader.authorization(bearerToken: user.accessToken)
        ])
        
        let request = makeRequest(url: url, type: "dialog/message", attributes: ["dialog_id": self.dialogId, "message_text" : msg], headers: headers)
        
        request.responseJSON { response in
            switch response.result{
            case .success(_):
                let httpResponse = response.response!
                                
                if httpResponse.statusCode == 201{
                    print("success")
                }else{
                    print("fail")
                }
                
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
    
    private func makeRequest(url: String, type: String, attributes: Encodable, headers: HTTPHeaders) -> DataRequest {
        let parameters = [
            "data": [
                "type": type,
                "attributes": attributes
            ]
        ]
        
        return Alamofire.AF.request(url, method: .post, parameters: parameters, headers: headers){
            request in
            request.timeoutInterval = 5
        }
    }
    
    private func formatDate(dateStr:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var result = ""
        if let date = dateFormatterGet.date(from: dateStr) {
            result = dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
        }
        
        return result
    }
    
    private func isNewMessage(msg: DetailMessage) -> Bool{

        let createdAt = msg.createdAt

        var result = false
        
        let lastmsgTime = chatHistory.last!.createdAt
        
        if createdAt != lastmsgTime {
            result = true
        }
        
        return result
        
    }
}

struct DetailMessage: Codable, Identifiable, Equatable, Hashable{
    var id = UUID()
    var createdAt: String = ""
    var text:String = ""
    var isMe:Bool = false
    var member: Member = Member()
}
