//
//  FoodContent.swift
//  WinnipegLife
//
//  Created by changming wang on 8/19/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class Food: ObservableObject {
    
    let mainBaseUrl = BaseUrl().url

    
    @Published var inited:Bool = false
    @Published var isLoading:Bool = true
    @Published var titleList:[String] = ["全部"]
    @Published var threads: [[CommonThread]] = []
    @Published var models: [[CommonViewModel]] = []
    
    
    @Published var selection = 0 {
        didSet {
            if !loaded[selection]{
                isLoading = true
//                requestData()
                fetchData()
            }
        }
    }
    
    @Published var noMoreData:[Bool] = []
    
    
    private var seacrchIds:[String] = []
    private var pageNumber:[Int] = []
    private var idStrings:String = ""
    private var loaded:[Bool] = []
    
    private var restaIds:[String] = []
    private var restaNames:[String] = ["全部"]
    
    private var categoryIds:[String:String] = [:]
    
    init() {
        initData()
    }
    
    func initData(){
        
        let url = mainBaseUrl + "mcategories"
        
        AF.request(url).responseJSON {[weak self] response in
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let list = json["data"].arrayValue
                
                for dict in list{
                    
                    let name = dict["attributes"]["name"].string!
                    
                    if name == "XzResta"{
                        let id = dict["id"].string!
                        self.restaIds.append(id)

                        let children = dict["attributes"]["children"].arrayValue
                        let result = self.getChildrenIDs(children: children)
                        
                        self.restaIds += result.ids
                        self.restaNames += result.names
                        
                        if let foodID = foodNames.getFoodId(){
                            foodID.ids = self.restaIds
                            foodID.name = self.restaNames
                        }else{
                            let foodID = foodNames(context: CoreDataStack.shared.managedContext)
                            foodID.ids = self.restaIds
                            foodID.name = self.restaNames
                            CoreDataStack.shared.saveContext()
                        }
                        
                        
                        self.fetchResta()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    func fetchResta(){
        
        if let FoodId = foodNames.getFoodId(){
            titleList = FoodId.name!
            seacrchIds = FoodId.ids!
            for _ in 0..<self.titleList.count {
                pageNumber.append(1)
                threads.append([])
                loaded.append(false)
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
                let foodJson = JSON(data)
                let foodList = foodJson["Data"]["pageData"].arrayValue
                if foodList.count > 0 {
                    for food in foodList{
                        var thread = CommonThread()
                        let user = food["user"]
                        thread.userName = user["userName"].string ?? ""
                        thread.userAvatar = user["avatar"].string ?? ""
                        let th = food["thread"]
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
                self.inited = true
                
                
            case.failure(let error):
                print(error)
            }
        }
        
    }
    
    func fetchData() {
        
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
                let merchantsJson = JSON(data)
                let merchantsList = merchantsJson["Data"]["pageData"].arrayValue
                if merchantsList.count > 0{
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
                        thread.storeId = String(th["storeWebStoreId"].intValue)
                        thread.viewCount = th["viewCount"].int ?? 0
                        
                        let attachments = merchant["attachment"].arrayValue
                        for attachment in attachments{
                            let item = attachment.dictionary!
                            let fileType = item["fileType"]?.string ?? ""
                            if self.checkAttachmentFileType(file: fileType) == "image"{
                                let url = item["url"]?.string ?? ""
                                if url != ""{
                                    thread.imageUrls.append(url)
                                }
                            }
                        }
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
    
    private func checkAttachmentFileType(file:String) -> String{
       return file.components(separatedBy: "/")[0]
    }
    
}
