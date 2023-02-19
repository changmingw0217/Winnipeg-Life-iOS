//
//  Community.swift
//  WinnipegLife
//
//  Created by changming wang on 6/27/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class Community: ObservableObject{
    
    let mainBaseUrl = BaseUrl().url
    
    @Published var isLoading:Bool = false
    @Published var titleList:[String] = ["全部"]
    @Published var threads: [[CommonThread]] = []
    @Published var models: [[DetailCommunityViewModel]] = []
    
    @Published var selection:Int {
        didSet {
//            print("Current selection is \(selection)")
            if !loaded[selection]{
                isLoading = true
                fetchData()
            }
        }
    }
    
    @Published var noMoreData:[Bool] = []
    
    
    private var seacrchIds:[String] = []
    private var pageNumber:[Int] = []
    private var idStrings:String = ""
    private var loaded:[Bool] = []
    private var categoryIds:[String:String] = CategoryDict.getCategoryDict()!.dict!
    
    init(selection: Int) {
        self.selection = selection
        isLoading = true
        initData()
        fetchData()
    }
    
    func initData() {
        if let communityID = CommunityID.getCommunityID(){
            titleList = communityID.name!
            seacrchIds = communityID.ids!
            for _ in 0..<self.titleList.count {
                pageNumber.append(1)
                threads.append([])
                loaded.append(false)
                models.append([])
                noMoreData.append(false)
            }
            
            print(seacrchIds)
            
        }
        
        for index in 0..<self.seacrchIds.count {
            let idString = "&filter[categoryids][" + String(index) + "]=" + seacrchIds[index]
            idStrings += idString
        }
    }
    
    func fetchData(){
        
        isLoading = true
//        print("Loading Status \(isLoading)")
        var baseUrl = ""
        
        if selection == 0 {
//            baseUrl = "https://media.lifewpg.ca/api/mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0" + idStrings
            
            baseUrl = mainBaseUrl + "mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0" + idStrings
        }else{
//            baseUrl = "https://media.lifewpg.ca/api/mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + seacrchIds[selection]
            
            baseUrl = mainBaseUrl + "mthreads.v2?page=" + String(pageNumber[selection]) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + seacrchIds[selection - 1]
            
        }
        
        
        let currentSelection = self.selection
        self.pageNumber[currentSelection] += 1
        
        
        AF.request(baseUrl).responseJSON {[weak self] response in
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
                                    
                                }
                            }
                        }
                        
                        self.threads[currentSelection].append(thread)
                        self.models[currentSelection].append(DetailCommunityViewModel(pid: String(thread.pid)))

                    }

                }
                else{
                    self.noMoreData[currentSelection] = true
                }
                
                self.loaded[currentSelection] = true
                self.isLoading = false
//                print("Loading Status \(self.isLoading)")

            case.failure(let error):
                print(error)
            }
        }
        

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
    
    private func checkAttachmentFileType(file:String) -> String{
       return file.components(separatedBy: "/")[0]
    }

}
