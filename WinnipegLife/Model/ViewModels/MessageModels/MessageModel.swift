//
//  MessageModel.swift
//  WinnipegLife
//
//  Created by changming wang on 7/11/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI

class Message: ObservableObject{
    
    let baseUrl = BaseUrl().url
    
    @Published var chats:[Chat] = []
    
    @Published var notifications:[NotificationData] = []
    
    @Published var loadingNotifications:Bool = false
    
    @Published var loadingMessage: Bool = false
    
    @Published var isDeletingMessage:Bool = false
    
    
    private var messageDatas:[String:MessageData] = [:]
    
    private var userDatas:[String:MessageUserData] = [:]
    
    
    func fetchMessage(){
        let now = Date()
        print("刷新message + \(now)")
        self.loadingMessage = true
        if let user = UserManager.user{
            
            if !isDeletingMessage{
                let userId = user.id
                
                let url = baseUrl + "dialog?include=dialogMessage,sender,recipient&sort=-dialogMessageId"
                
                    
//                let url = "https://media.lifewpg.ca/api/dialog?include=dialogMessage,sender,recipient&sort=-dialogMessageId"

                let headers : HTTPHeaders = HTTPHeaders.init([

                    HTTPHeader.authorization(bearerToken: user.accessToken)
                ])

                let request = AF.request(url, headers: headers)

                request.responseJSON { [weak self] response in
                    
                    guard let self = self else { return }
                    
                    switch response.result{
                    case .success(let value):
                        let datas = JSON(value)
                        let data = datas["data"].arrayValue
                        let included = datas["included"].arrayValue
                        var chatList:[Chat] = []
                        
                        for chat in data{
                            
                            var chatData = Chat()
                            let dialogId = chat["id"].stringValue
                            let attributes = chat["attributes"].dictionaryValue
                            let sender_user_id = String(attributes["sender_user_id"]!.intValue)
                            let recipient_user_id = String(attributes["recipient_user_id"]!.intValue)
                            let recipient_read_at = attributes["recipient_read_at"]?.string ?? ""
                            let sender_read_at = attributes["sender_read_at"]?.string ?? ""
                            let dialog_message_id = attributes["dialog_message_id"]!.stringValue
                            
                            chatData.dialogId = dialogId
                            
                            chatData.memberId = userId == sender_user_id ? recipient_user_id : sender_user_id
                            
                            chatData.isUserSender = userId == sender_user_id ? true : false
                            
                            chatData.recipientReadTime = recipient_read_at
                            chatData.senderReadTime = sender_read_at
                            
                            chatData.chatID = dialog_message_id

    //                        print("sender: \(String(describing: sender_user_id))")
    //                        print("recive: \(String(describing: recipient_user_id))")
    //                        print(recipient_read_at)
                            
                            chatList.append(chatData)
                            
    //                        print("chat id \(chatData.chatID)")
    //                        print("对象 id \(chatData.recipientId)")
                        }
                        
                        for include in included{
                            let type = include["type"].stringValue
                            let id = include["id"].stringValue
                            if type == "dialog_message"{
                                var messageData = MessageData()
                                let attr = include["attributes"].dictionaryValue
                                let summary = attr["summary"]!.stringValue
                                let time = self.formatDate(dateStr: attr["updated_at"]!.stringValue)
                                
                                messageData.messageContent = summary
                                messageData.messageTime = time
                                
                                self.messageDatas[id] = messageData
                            }else if type == "users" {
                                var userData = MessageUserData()
                                let attr = include["attributes"].dictionaryValue
                                let username = attr["username"]!.stringValue
                                let avatar = attr["avatarUrl"]!.stringValue
                                
                                userData.userName = username
                                userData.userAvatar = avatar
                                
                                self.userDatas[id] = userData
                            }
                        }
                        
                        for index in chatList.indices {
                            let contentID = chatList[index].chatID
                            let content = self.messageDatas[contentID]?.messageContent
                            let time = self.messageDatas[contentID]?.messageTime
                            
                            chatList[index].desc = content!
                            chatList[index].time = time!
                            
                            let memberId = chatList[index].memberId
                            var member = Member()
                            let recipientData = self.userDatas[memberId]!
                            member.name = recipientData.userName
                            member.icon = recipientData.userAvatar
                            
                            chatList[index].member = member
                            
                        }
                        
                        for index in self.chats.indices {
                            let dialogId = self.chats[index].dialogId
                            let offset = self.chats[index].offset
                            let isSwiped = self.chats[index].isSwiped
                            
                            for i in chatList.indices{
                                let id = chatList[i].dialogId
                                if id == dialogId{
                                    chatList[i].offset = offset
                                    chatList[i].isSwiped = isSwiped
                                    break
                                }
                            }
                            
                        }
                        
    //                    print(chatList)
                        if !self.isDeletingMessage{
                            self.chats = chatList
                        }
                        
                        self.loadingMessage = false
    //                    print(self.chats)
                        
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
    }
    
    func fetchnotification(){
        let now = Date()
        print("系统通知 + \(now)")
        
        self.loadingNotifications = true
        
        
        if let user = UserManager.user{
            
            let url = baseUrl + "notification?filter[type]=system"
            
//            let url = "https://media.lifewpg.ca/api/notification?filter[type]=system"
            
            let headers : HTTPHeaders = HTTPHeaders.init([

                HTTPHeader.authorization(bearerToken: user.accessToken)
            ])
            
            let request = AF.request(url, headers: headers)
            
            request.responseJSON { [weak self] response in
                
                guard let self = self else { return }
                
                switch response.result{
                case .success(let value):
                    let datas = JSON(value)
                    let dataList = datas["data"].arrayValue
                    var notificationList:[NotificationData] = []
                                        
                    for data in dataList{
                        var notificationData = NotificationData()
                        let attributes = data["attributes"].dictionaryValue
                        
                        let id = String(attributes["id"]!.intValue)
                        let title = attributes["title"]!.stringValue
                        let content = attributes["content"]!.stringValue
                        let createdAt = self.formatDate(dateStr: attributes["created_at"]!.stringValue)
                        
                        notificationData.notificationId = id
                        notificationData.title = title
                        notificationData.content = content
                        notificationData.createdAt = createdAt
                        
                        notificationList.append(notificationData)
                        
                    }
                    
                    self.notifications = notificationList
                    
                    self.loadingNotifications = false
                    
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
    
    func deleteDialog(dialogId:String){
        
        if let user = UserManager.user{
            let headers : HTTPHeaders = HTTPHeaders.init([

                HTTPHeader.authorization(bearerToken: user.accessToken)
            ])
            
            let url = baseUrl + "dialog/" + dialogId
            
//            let url = "https://media.lifewpg.ca/api/dialog/" + dialogId
            
            let request = AF.request(url, method: .delete, parameters: nil, headers: headers)
            
            request.responseJSON { response in
                
                switch response.result{
                case .success(_):
                    let httpResponse = response.response!
                    
                    if httpResponse.statusCode == 204{
                        print("success")
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
    }
    
    func deleteNotification(nitificationId:String) {
        
        if let user = UserManager.user{
            let headers : HTTPHeaders = HTTPHeaders.init([

                HTTPHeader.authorization(bearerToken: user.accessToken)
            ])
            
            let url = baseUrl + "notification/" + nitificationId
            
//            let url = "https://media.lifewpg.ca/api/notification/" + nitificationId
            
            let request = AF.request(url, method: .delete, parameters: nil, headers: headers)
            
            request.responseJSON { response in
                
                switch response.result{
                case .success(_):
                    let httpResponse = response.response!
                    
                    if httpResponse.statusCode == 204{
                        self.isDeletingMessage = false
                        
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
    }
    
    func cleanData(){
        chats = []
        notifications = []
        messageDatas = [:]
        userDatas = [:]
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


struct Member: Codable, Equatable, Identifiable, Hashable {
    var id = UUID()
    var icon: String = ""
    var name: String = ""
}

struct Chat:Codable, Equatable, Identifiable, Hashable {
    var id = UUID()
    var chatID = ""
    var desc: String = ""
    var member: Member = Member()
    var time: String = ""
    var memberId:String = ""
    var isUserSender: Bool = false
    var senderReadTime:String = ""
    var recipientReadTime:String = ""
    var dialogId:String = ""
    var offset:CGFloat = .zero
    var isSwiped:Bool = false
}

struct MessageData: Identifiable {
    var id = UUID()
    var messageContent = ""
    var messageTime = ""
}

struct MessageUserData: Identifiable {
    var id = UUID()
    var userAvatar = ""
    var userName = ""
}


struct NotificationData: Codable, Equatable, Identifiable, Hashable {
    var id = UUID()
    var notificationId:String = ""
    var title:String = ""
    var content:String = ""
    var createdAt:String = ""
    var offset:CGFloat = .zero
    var isSwiped:Bool = false
}
