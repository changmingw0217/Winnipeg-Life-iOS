//
//  News.swift
//  WinnipegLife
//
//  Created by changming wang on 6/6/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class News: ObservableObject{
    
    let mainBaseUrl = BaseUrl().url
    
    @Published var isLoading:Bool = false
    @Published var titleList:[String] = ["全部"]
    @Published var isRefreshing:[Bool] = []
    @Published var threads: [[CommonThread]] = []
    @Published var models: [[CommonViewModel]] = []
    
    @Published var selection = 0 {
        didSet {
            if !loaded[selection]{
                isLoading = true
                requestData()
            }
        }
    }
    
    @Published var noMoreData:[Bool] = []
    
    
    private var seacrchIds:[String] = []
    private var pageNumber:[Int] = []
    private var idStrings:String = ""
    private var loaded:[Bool] = []
    private var categoryIds:[String:String] = CategoryDict.getCategoryDict()!.dict!
    
    init() {
        isLoading = true
        initData()
    }
    
    func initData(){
        
        if let newsId = NewsId.getNewsId(){
            titleList = newsId.name!
            seacrchIds = newsId.ids!
            for _ in 0..<self.titleList.count {
                pageNumber.append(1)
                threads.append([])
                loaded.append(false)
                isRefreshing.append(false)
                models.append([])
                noMoreData.append(false)
            }
            
        }
        
//        var baseUrl = "https://media.lifewpg.ca/api/mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0"
        
        var baseUrl = mainBaseUrl + "mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0"
        
        let currentSelection = self.selection
        pageNumber[currentSelection] += 1
        
        for index in 0..<self.seacrchIds.count {
            let idString = "&filter[categoryids][" + String(index) + "]=" + seacrchIds[index]
            idStrings += idString
            baseUrl += idString
        }
        
        AF.request(baseUrl).responseJSON {[weak self] response in
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
                    self.threads[currentSelection].append(thread)
                    self.models[currentSelection].append(CommonViewModel(pid: String(thread.pid)))
                    
                }
                self.loaded[currentSelection] = true
                self.isLoading = false
            case.failure(let error):
                print(error)
            }
        }
        

    }
    
    
    func requestData() {
        
        isLoading = true
        
        var baseUrl = ""
        
        if selection == 0 {
//            baseUrl = "https://media.lifewpg.ca/api/mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0" + idStrings
            
            baseUrl = mainBaseUrl + "mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0" + idStrings
        }else{
//            baseUrl = "https://media.lifewpg.ca/api/mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + seacrchIds[selection]
            
            baseUrl = mainBaseUrl + "mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + seacrchIds[selection]
        }
        
        let currentSelection = self.selection
        
        pageNumber[currentSelection] += 1

        AF.request(baseUrl).responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case.success(let data):
                let newsJson = JSON(data)
                let newsList = newsJson["Data"]["pageData"].arrayValue
                if newsList.count > 0 {
                    for new in newsList{
                        var thread = CommonThread()
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
                        self.threads[currentSelection].append(thread)
                        self.models[currentSelection].append(CommonViewModel(pid: String(thread.pid)))
                    }
                }else{
                    self.noMoreData[currentSelection] = true
                }
                
                self.loaded[currentSelection] = true
                self.isLoading = false

            case.failure(let error):
                print(error)
            }
        }


        
    }
    
    func refreshPage(){
        isRefreshing[selection] = true
        
        var baseUrl = ""
        
        if selection == 0 {
            baseUrl = mainBaseUrl + "mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0" + idStrings
        }else{
            baseUrl = mainBaseUrl + "mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + seacrchIds[selection]
        }
        
        let currentSelection = self.selection
        
        pageNumber[currentSelection] = 1
        
        AF.request(baseUrl).responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case.success(let data):
                let newsJson = JSON(data)
                let newsList = newsJson["Data"]["pageData"].arrayValue
                if newsList.count > 0 {
                    for new in newsList{
                        var thread = CommonThread()
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
                        self.threads[currentSelection].append(thread)
                        self.models[currentSelection].append(CommonViewModel(pid: String(thread.pid)))
                    }
                }else{
                    self.noMoreData[currentSelection] = true
                }
                
                self.loaded[currentSelection] = true
                self.isLoading = false

            case.failure(let error):
                print(error)
            }
        }
    }
    
    private func diffCreated(str:String) -> String{
        var final = ""
        if !str.containsWhitespace{
            if str.count > 0{
                final = str + " ago"
            }
        }else{
            final = str.components(separatedBy: " ")[0]
        }
    
        return final
    }
}
