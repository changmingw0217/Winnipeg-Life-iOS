//
//  SearchModel.swift
//  WinnipegLife
//
//  Created by changming wang on 8/16/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchModel: ObservableObject {
    
    let baseUrl = BaseUrl().url
    
    @Published var isLoading:Bool = false
    //搜索关键词
    @Published var text:String = ""
    //帖子结果
    @Published var threadResult:[SearchThread] = []
    //用户结果
    @Published var userResult:[String] = []
    
//    @Published var queryError:Bool = false
    
    private var userInfos:[String:UserInfo] = [:]
    
    let merchantsID = MerchantsID.getMerchantsID()!.ids!
    let communityID = CommunityID.getCommunityID()!.ids!
    let localDiscoveriesId = LocalDiscoveriesId.getLocalDiscoveriesId()!.id!
    let newsId = NewsId.getNewsId()!.ids!
    
    
    func search() {
        
//        let result = self.checkQueryString()
//        
//        if !result{
//            queryError = true
//            return
//        }
        
        self.cleanUserInfo()
        
        
        let query = self.text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        
//        let url = "https://media.lifewpg.ca/api/threads?include=user,user.groups,firstPost,firstPost.images,category,threadVideo,question,question.beUser,question.beUser.groups,firstPost.postGoods,threadAudio&filter[isApproved]=1&filter[isDeleted]=no&filter[categoryId]=0&page[number]=1&page[limit]=10&filter[q]=" + query!
        
        let url = baseUrl + "threads?include=user,user.groups,firstPost,firstPost.images,category,threadVideo,question,question.beUser,question.beUser.groups,firstPost.postGoods,threadAudio&filter[isApproved]=1&filter[isDeleted]=no&filter[categoryId]=0&page[number]=1&page[limit]=10&filter[q]=" + query!
        
        self.isLoading = true
        
        
        AF.request(url).responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let datas = json["data"].arrayValue
                
                var result:[SearchThread] = []
                
                for data in datas{
                    var thread = SearchThread()
                    
                
                    let attributes = data["attributes"].dictionaryValue
                    let id = attributes["id"]?.intValue
                    thread.pid = id!
                    
                    let title = attributes["title"]!.stringValue
                    let postContent = attributes["postContent"]!.stringValue
                    
                    if title.isEmpty{
                        thread.title = postContent
                    }else{
                        thread.title = title
                    }
                    
                    let createdAt = self.formatDate(dateStr: attributes["createdAt"]!.stringValue)
                    thread.createdAt = createdAt
                    
                    let viewCount = attributes["viewCount"]!.intValue
                    thread.viewCount = viewCount
                    
                    let postCount = attributes["postCount"]!.intValue
                    thread.postCount = postCount - 1
                    
                    let relationships = data["relationships"].dictionaryValue
                    
                    let user = relationships["user"]!.dictionaryValue
                    let userData = user["data"]!.dictionaryValue
                    let userId = userData["id"]!.stringValue
                    
                    thread.userId = userId
                    
                    let category = relationships["category"]!.dictionaryValue
                    let categoryData = category["data"]!.dictionaryValue
                    let categoryId = categoryData["id"]!.stringValue
                    
                    thread.categoriesID = categoryId
                    
                    result.append(thread)
                    
                    
                }
                
                let includeds = json["included"].arrayValue
                
                for included in includeds{
                    let type = included["type"].stringValue
                    if type == "users"{
                        var userInfo = UserInfo()

                        let id = included["id"].stringValue
                        
                        let attributes = included["attributes"].dictionaryValue
                        
                        let username = attributes["username"]!.stringValue
                        
                        let avatarUrl = attributes["avatarUrl"]!.stringValue
                        
                        userInfo.userName = username
                        userInfo.userAvatar = avatarUrl
                        
                        self.userInfos[id] = userInfo
                        
                    }
                }
                
                for index in result.indices{
                    let userId = result[index].userId
                    let userInfo = self.userInfos[userId]
                    result[index].userName = userInfo!.userName
                    result[index].userAvatar = userInfo!.userAvatar
                    
                    result[index].categoryName = self.checkCategory(result[index].categoriesID)
                    print(result[index].categoryName)
                }
                
                self.isLoading = false
                self.threadResult = result
                
                
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
    
    private func cleanUserInfo(){
        userInfos = [:]
    }
    
//    private func checkQueryString() -> Bool{
//        
//        var result = true
//        
//        for scalar in self.text.unicodeScalars{
//            let isEmoji = scalar.properties.isEmoji
//            print(isEmoji)
//            if isEmoji{
//                result = false
//                break
//            }
//        }
//        
//        return result
//    }
    
    private func checkCategory(_ id:String) -> String{
        var result = ""
        
        if id == localDiscoveriesId{
            result = "local"
        }else if (merchantsID.contains(id))  {
            result = "merchant"
        }else if (communityID.contains(id))  {
            result = "community"
        }else if (newsId.contains(id)){
            result = "news"
        }
        
        return result
    }
    
    private func formatDate(dateStr:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        var result = ""
        if let date = dateFormatterGet.date(from: dateStr) {
            result = dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
        }
        
        return result
    }
}


struct SearchImageInfo:Identifiable {
    var id = UUID()
    var pid:String = ""
    var thumbUrl:String = ""
    
}
