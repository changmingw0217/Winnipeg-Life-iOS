//
//  HomePageContents.swift
//  WinnipegLife
//
//  Created by changming wang on 6/5/21.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON
import SDWebImageSwiftUI

class Home: ObservableObject{
    
    let baseUrl = BaseUrl().url
    
    @Published var loaded: Bool = false
    @Published var noMoreData:Bool = false
    
    
    @Published var load: Bool = false
    
    @Published var isLoading: Bool = false
    
    @Published var refreshing: Bool = false
    
    @Published var banner: BannerModel = BannerModel()
    @Published var bannerModels: [CommonViewModel] = []
    
    @Published var newsThreads:[CommonThread] = []
    @Published var newsModels:[CommonViewModel] = []
    
    @Published var merchantsThreads:[CommonThread] = []
    @Published var merchantsModels:[CommonViewModel] = []
    
    @Published var communityThreads:[CommonThread] = []
    @Published var communityModels:[DetailCommunityViewModel] = []
    
        

    private var communityPage:Int = 1
    private var bannerID:String = ""
    
    private var newsIds:[String] = []
    private var newsNames:[String] = ["全部"]
    private var merchantIds:[String] = []
    private var merchantNames:[String] = ["全部"]
    private var communityIds:[String] = []
    private var communityNames:[String] = ["全部"]
    private var clubIds:[String] = []
    private var clubNames:[String] = ["全部"]
    
    
    private var categoryIds:[String:String] = [:]
    
    private var newsLoaded:Bool = false {
        didSet{
            loaded = newsLoaded && bannerLoaded && merchantLoaded && communityLoaded
//            print(loaded)
        }
    }
    private var bannerLoaded: Bool = false {
        didSet{
            loaded = newsLoaded && bannerLoaded && merchantLoaded && communityLoaded
//            print(loaded)
        }
    }
    
    private var merchantLoaded:Bool = false {
        didSet{
            loaded = newsLoaded && bannerLoaded && merchantLoaded && communityLoaded
//            print(loaded)
        }
    }
    
    private var communityLoaded:Bool = false {
        didSet{
            loaded = newsLoaded && bannerLoaded && merchantLoaded && communityLoaded
//            print(loaded)
        }
    }
    
    
    init() {
        requestData()
//        requestTestData()
    }
    
    
    func requestData() {
        AF.request("https://lifewpg.com/api/mcategories").responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let list = json["data"].arrayValue
                
                for dict in list{
                    let name = dict["attributes"]["name"].string!
                    

                    if name == "XzBanner" {
                        let bannerID = dict["id"].string!
                        self.bannerID = bannerID

                        self.requestBanner()
                    }
                    
                    else if name == "灌水" {
                        let id = dict["id"].string!
                        self.categoryIds[id] = name
                        
                        self.communityIds.append(id)
                        self.communityNames.append(name)
                        
                        
                    }
                    
                    else if name == "灌水" {
                        let id = dict["id"].string!
                        self.categoryIds[id] = name
                        
                        self.communityIds.append(id)
                        self.communityNames.append(name)
                        
                    }
                    
                    else if name == "租房" {
                        let id = dict["id"].string!

                        self.categoryIds[id] = name
                        
                        self.communityIds.append(id)
                        self.communityNames.append(name)
                        

                    }

                    else if name == "二手" {
                        let id = dict["id"].string!

                        self.categoryIds[id] = name
                        
                        self.communityIds.append(id)
                        self.communityNames.append(name)
                        

                    }

                    else if name == "爆料" {
                        let id = dict["id"].string!

                        self.categoryIds[id] = name
                        
                        self.communityIds.append(id)
                        self.communityNames.append(name)
                        

                    }
                    
                    else if name == "聊天" {
                        let id = dict["id"].string!

                        self.categoryIds[id] = name
                        
                        self.communityIds.append(id)
                        self.communityNames.append(name)

                    }

                    else if name == "交友" {
                        let id = dict["id"].string!

                        self.categoryIds[id] = name
                        
                        self.communityIds.append(id)
                        self.communityNames.append(name)
                        
                    }
                    
                    else if name == "亲子" {
                        let id = dict["id"].string!

                        self.categoryIds[id] = name
                        
                        self.communityIds.append(id)
                        self.communityNames.append(name)

                    }
                    
                    else if name == "宠物" {
                        let id = dict["id"].string!

                        self.categoryIds[id] = name
                        
                        self.communityIds.append(id)
                        self.communityNames.append(name)
                        
                    }

                    
                    else if name == "XzNews"{
                        let id = dict["id"].string!
                        self.newsIds.append(id)
                        self.categoryIds[id] = "新闻"
                        let children = dict["attributes"]["children"].arrayValue
                        let result = self.getChildrenIDs(children: children)
                        self.newsIds += result.ids
                        self.newsNames += result.names
                        
                        
                        if let newsId = NewsId.getNewsId(){
                            newsId.name = self.newsNames
                            newsId.ids = self.newsIds
                        }else{
                            let newsId = NewsId(context: CoreDataStack.shared.managedContext)
                            newsId.name = self.newsNames
                            newsId.ids = self.newsIds
                            CoreDataStack.shared.saveContext()
                        }
                        
                        self.fetchNews()
                    }
                    
                    else if name == "XzTanDian"{
                        let id = dict["id"].string!
                        self.categoryIds[id] = "探店"
                        if let LocalDiscoveriesId = LocalDiscoveriesId.getLocalDiscoveriesId(){
                            LocalDiscoveriesId.id = id
                        }else{
                            let LocalDiscoveriesId = LocalDiscoveriesId(context: CoreDataStack.shared.managedContext)
                            LocalDiscoveriesId.id = id
                            CoreDataStack.shared.saveContext()
                        }
                    }
                    
                    else if name == "XzBusiness"{
                        let id = dict["id"].string!
                        self.merchantIds.append(id)
                        self.categoryIds[id] = "商家"
                        let children = dict["attributes"]["children"].arrayValue
                        let result = self.getChildrenIDs(children: children)
                        self.merchantIds += result.ids
                        self.merchantNames += result.names
                        
                        
                        if let merchantsID = MerchantsID.getMerchantsID(){
                            merchantsID.ids = self.merchantIds
                            merchantsID.name = self.merchantNames
                        }else{
                            let merchantsID = MerchantsID(context: CoreDataStack.shared.managedContext)
                            merchantsID.ids = self.merchantIds
                            merchantsID.name = self.merchantNames
                            CoreDataStack.shared.saveContext()
                        }
                        
                        self.fetchMerchants()
                        
                    }
                    
                    else if name == "部落" {
                        let id = dict["id"].string!
                        self.clubIds.append(id)
                        self.categoryIds[id] = "部落"
                        let children = dict["attributes"]["children"].arrayValue
                        let result = self.getChildrenIDs(children: children)
                        self.clubIds += result.ids
                        self.clubNames += result.names
                        
                        if let clubID = ClubID.getClubID(){
                            clubID.ids = self.clubIds
                            clubID.name = self.clubNames
                        }else{
                            let clubID = ClubID(context: CoreDataStack.shared.managedContext)
                            clubID.ids = self.clubIds
                            clubID.name = self.clubNames
                            CoreDataStack.shared.saveContext()
                        }
                    }
                    
                }
                
                if let communityID = CommunityID.getCommunityID(){
                    communityID.ids = self.communityIds
                    communityID.name = self.communityNames

                }else{
                    let communityID = CommunityID(context: CoreDataStack.shared.managedContext)
                    communityID.ids = self.communityIds
                    communityID.name = self.communityNames

                    CoreDataStack.shared.saveContext()
                }
                
                if let categoryDict = CategoryDict.getCategoryDict(){
                    categoryDict.dict = self.categoryIds
                }else{
                    let categoryDict = CategoryDict(context: CoreDataStack.shared.managedContext)
                    categoryDict.dict = self.categoryIds
                    CoreDataStack.shared.saveContext()
                }
                
                self.fetchCommunity()
                
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
                }else{
                    self.requestData()
                }
            }
        }
    }
    
    func requestTestData() {

        AF.request("https://media.lifewpg.ca/api/mcategories").responseJSON {[weak self] response in
            guard let self = self else { return }

            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let list = json["data"].arrayValue

                for dict in list{

                    let name = dict["attributes"]["name"].string!

                    if name == "XzBanner" {
                        let bannerID = dict["id"].string!
                        
                        self.bannerID = bannerID
                        self.requestBanner()
                    }

                    else if name == "XzNews"{
                        let id = dict["id"].string!
                        self.newsIds.append(id)
                        self.categoryIds[id] = "新闻"
                        let children = dict["attributes"]["children"].arrayValue
                        let result = self.getChildrenIDs(children: children)
                        self.newsIds += result.ids
                        self.newsNames += result.names


                        if let newsId = NewsId.getNewsId(){
                            newsId.name = self.newsNames
                            newsId.ids = self.newsIds
                        }else{
                            let newsId = NewsId(context: CoreDataStack.shared.managedContext)
                            newsId.name = self.newsNames
                            newsId.ids = self.newsIds
                            CoreDataStack.shared.saveContext()
                        }

                        self.fetchNews()
                    }

                    else if name == "XzTanDian"{

                        let id = dict["id"].string!
                        self.categoryIds[id] = "探店"
                        if let LocalDiscoveriesId = LocalDiscoveriesId.getLocalDiscoveriesId(){
                            LocalDiscoveriesId.id = id
                        }else{
                            let LocalDiscoveriesId = LocalDiscoveriesId(context: CoreDataStack.shared.managedContext)
                            LocalDiscoveriesId.id = id
                            CoreDataStack.shared.saveContext()
                        }
                    }

                    else if name == "XzBusiness"{
                        let id = dict["id"].string!
                        self.merchantIds.append(id)
                        self.categoryIds[id] = "商家"
                        let children = dict["attributes"]["children"].arrayValue
                        let result = self.getChildrenIDs(children: children)
                        self.merchantIds += result.ids
                        self.merchantNames += result.names


                        if let merchantsID = MerchantsID.getMerchantsID(){
                            merchantsID.ids = self.merchantIds
                            merchantsID.name = self.merchantNames
                        }else{
                            let merchantsID = MerchantsID(context: CoreDataStack.shared.managedContext)
                            merchantsID.ids = self.merchantIds
                            merchantsID.name = self.merchantNames
                            CoreDataStack.shared.saveContext()
                        }

                        self.fetchMerchants()

                    }


                    else if name == "社区分组 A" {
                        let id = dict["id"].string!
                        self.communityIds.append(id)
                        self.categoryIds[id] = "社区"
                        let children = dict["attributes"]["children"].arrayValue
                        let result = self.getChildrenIDs(children: children)
                        self.communityIds += result.ids
                        self.communityNames += result.names

                        if let communityID = CommunityID.getCommunityID(){
                            communityID.ids = self.communityIds
                            communityID.name = self.communityNames
                        }else{
                            let communityID = CommunityID(context: CoreDataStack.shared.managedContext)
                            communityID.ids = self.communityIds
                            communityID.name = self.communityNames
                            CoreDataStack.shared.saveContext()
                        }

                        self.fetchCommunity()
                    }
                    else if name == "部落" {
                        let id = dict["id"].string!
                        self.clubIds.append(id)
                        self.categoryIds[id] = "部落"
                        let children = dict["attributes"]["children"].arrayValue
                        let result = self.getChildrenIDs(children: children)
                        self.clubIds += result.ids
                        self.clubNames += result.names

                        if let clubID = ClubID.getClubID(){
                            clubID.ids = self.clubIds
                            clubID.name = self.clubNames
                        }else{
                            let clubID = ClubID(context: CoreDataStack.shared.managedContext)
                            clubID.ids = self.clubIds
                            clubID.name = self.clubNames
                            CoreDataStack.shared.saveContext()
                        }
                    }

                }

                if let categoryDict = CategoryDict.getCategoryDict(){
                    categoryDict.dict = self.categoryIds
                }else{
                    let categoryDict = CategoryDict(context: CoreDataStack.shared.managedContext)
                    categoryDict.dict = self.categoryIds
                    CoreDataStack.shared.saveContext()
                }


            case.failure(let error):
                print(error)
            }
        }
    }
    
    func requestBanner(){
//        let url = "https://media.lifewpg.ca/api/mthreads.v2?page=1&perPage=6&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + id
        
        let url = baseUrl + "mthreads.v2?page=1&perPage=6&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + self.bannerID
        
        AF.request(url).responseJSON { response in
            
            switch response.result{
            case.success(let data):

                let bannerData = JSON(data)
                let bannerList = bannerData["Data"]["pageData"].arrayValue
                
                for bannerDetail in bannerList{
                    let imageUrl = bannerDetail["thread"]["storeCover"].string!
                    let _ = WebImage(url: URL(string: imageUrl))
                    self.banner.imageUrls.append(imageUrl)
                    let bannerPid = String(bannerDetail["thread"]["pid"].intValue)
                    self.banner.pids.append(bannerPid)
                    self.bannerModels.append(CommonViewModel(pid: bannerPid))
                }
                
                self.bannerLoaded = true

            case.failure(let error):
                
                print("error banner")
                
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
                }else{
                    self.requestBanner()
                }
            }

        }
        
    }
    
   func fetchNews(){
//        var url = "https://media.lifewpg.ca/api/mthreads.v2?page=1&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0"
       
        var url = baseUrl + "mthreads.v2?page=1&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0"
        
        for index in 0..<newsIds.count {
            let idString = "&filter[categoryids][" + String(index) + "]=" + newsIds[index]
            url += idString
        }
        
        AF.request(url).responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case.success(let data):
                let newsJson = JSON(data)
                let newsList = newsJson["Data"]["pageData"].arrayValue
                for new in newsList{
                    var thread = CommonThread()
                    let user = new["user"]
                    thread.userName = user["userName"].string ?? ""
                    thread.userAvatar = user["avatar"].string ?? ""
                    let th = new["thread"]
                    thread.pid = th["pid"].intValue
                    thread.createdAt = th["createdAt"].string!.components(separatedBy: " ")[0]
                    thread.categoryId = self.categoryIds[String(th["categoryId"].int ?? 0)] ?? ""
                    thread.title = th["title"].string ?? ""
                    thread.summary = th["summary"].string ?? ""
                    thread.storeCover = th["storeCover"].string ?? ""
                    thread.storeName = th["storeName"].string ?? ""
                    thread.storeDesc = th["storeDesc"].string ?? ""
                    thread.viewCount = th["viewCount"].int ?? 0
                    self.newsThreads.append(thread)
                    self.newsModels.append(CommonViewModel(pid: String(thread.pid)))
                }
                self.newsLoaded = true
            case.failure(let error):
                print(error)
                print("error news")
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
                }else{
                    self.fetchNews()
                }

            }
        }
        
    }
    
    func fetchMerchants(){
//        var url = "https://media.lifewpg.ca/api/mthreads.v2?page=1&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0"
        
        var url = baseUrl + "mthreads.v2?page=1&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0"
        
        for index in 0..<merchantIds.count {
            let idString = "&filter[categoryids][" + String(index) + "]=" + merchantIds[index]
            url += idString
        }
        
        AF.request(url).responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case.success(let data):
                let merchantsJson = JSON(data)
                let merchantsList = merchantsJson["Data"]["pageData"].arrayValue
                for merchant in merchantsList{
                    var thread = CommonThread()
                    let user = merchant["user"]
                    thread.userName = user["userName"].string ?? ""
                    thread.userAvatar = user["avatar"].string ?? ""
                    let th = merchant["thread"]
                    thread.pid = th["pid"].intValue
                    thread.createdAt = th["createdAt"].string!.components(separatedBy: " ")[0]
                    thread.diffCreatedAt = self.diffCreated(str: th["diffCreatedAt"].string ?? "")
                    thread.categoryId = self.categoryIds[String(th["categoryId"].int ?? 0)] ?? ""
                    thread.title = th["title"].string ?? ""
                    thread.summary = th["summary"].string ?? ""
                    thread.storeCover = th["storeCover"].string ?? ""
                    thread.storeName = th["storeName"].string ?? ""
                    thread.storeDesc = th["storeDesc"].string ?? ""
                    thread.viewCount = th["viewCount"].int ?? 0
                    let attachments = merchant["attachment"].arrayValue
                    for attachment in attachments{
                        let item = attachment.dictionary!
                        let fileType = item["fileType"]?.string ?? ""
                        if self.checkAttachmentFileType(file: fileType) == "image"{
                            let url = item["thumbUrl"]?.string ?? ""
                            if url != ""{
                                thread.imageUrls.append(url)
                            }
                        }
                    }
                    self.merchantsThreads.append(thread)
                    self.merchantsModels.append(CommonViewModel(pid: String(thread.pid)))
                }
                self.merchantLoaded = true
            case.failure(let error):
                print(error)
                print("error merchant")
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
                }else{
                    self.fetchMerchants()
                }
            }
        }
        
    }
    
    func fetchCommunity(){
        self.isLoading = true
        
//        var url = "https://media.lifewpg.ca/api/mthreads.v2?page=" + String(communityPage) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0"
        
        var url = baseUrl + "mthreads.v2?page=" + String(communityPage) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0"
        
        communityPage += 1
        
        for index in 0..<communityIds.count {
    
            let idString = "&filter[categoryids][" + String(index) + "]=" + communityIds[index]
            url += idString
        }
        
        
        AF.request(url).responseJSON {[weak self] response in
            guard let self = self else { return }

            switch response.result{
            case.success(let data):
                let communityJson = JSON(data)
                let communityList = communityJson["Data"]["pageData"].arrayValue
                if communityList.count > 0 {
                    for community in communityList{
                        var thread = CommonThread()
                        let user = community["user"]
                        thread.userName = user["userName"].string ?? ""
                        thread.userAvatar = user["avatar"].string ?? ""
                        let th = community["thread"]
                        thread.pid = th["pid"].intValue
                        thread.createdAt = th["createdAt"].string!.components(separatedBy: " ")[0]
                        thread.diffCreatedAt = self.diffCreated(str: th["diffCreatedAt"].string ?? "")
                        thread.categoryId = self.categoryIds[String(th["categoryId"].int ?? 0)] ?? ""
                        thread.title = th["title"].string ?? ""
                        thread.summary = th["summary"].string ?? ""
                        thread.storeCover = th["storeCover"].string ?? ""
                        thread.storeName = th["storeName"].string ?? ""
                        thread.storeDesc = th["storeDesc"].string ?? ""
                        thread.viewCount = th["viewCount"].int ?? 0
                        let attachments = community["attachment"].arrayValue
                        for attachment in attachments{
                            let item = attachment.dictionary!
                            let fileType = item["fileType"]?.string ?? ""
                            if self.checkAttachmentFileType(file: fileType) == "image"{
                                let url = item["thumbUrl"]?.string ?? ""
                                if url != ""{
                                    thread.imageUrls.append(url)
                                    let _ = WebImage(url: URL(string: thread.imageUrls[0]))
                                }
                            }
                        }
                        self.communityThreads.append(thread)
                        self.communityModels.append(DetailCommunityViewModel(pid: String(thread.pid)))
                    }
                }else{
                    self.noMoreData = true
                }

                if !self.communityLoaded{
                    self.communityLoaded = true
                }

                self.isLoading = false

            case.failure(let error):
                print(error)
            }
        }
        
    }
    
    func refreshHomePage() {
        self.refreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshing = false
        }
        
    }
    
    
    private func getChildrenIDs(children: Array<JSON>) -> (names:[String], ids:[String]){
        var names:[String] = []
        var ids:[String] = []
        
        for child in children{
            let id = String(child["id"].int!)
            let name = child["name"].string!
            self.categoryIds[id] = name
            ids.append(id)
            names.append(name)
        }
        
        return (names, ids)
    }
    
    
    private func checkAttachmentFileType(file:String) -> String{
       return file.components(separatedBy: "/")[0]
    }
    
    private func diffCreated(str:String) -> String{
        var final = ""
        if !str.containsWhitespace{
            if str.count > 0{
                final = str + "前"
            }
        }else{
            final = str.components(separatedBy: " ")[0]
        }
    
        return final
    }
    

}

struct BannerModel: Codable, Hashable{
    var imageUrls:[String] = []
    var pids:[String] = []
}
