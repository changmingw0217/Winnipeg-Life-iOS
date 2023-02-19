//
//  File.swift
//  WinnipegLife
//
//  Created by changming wang on 6/15/21.
//

import Foundation
import Alamofire
import SwiftyJSON


class LocalDiscovery: ObservableObject{
    
    let baseUrl = BaseUrl().url
    
    @Published var isLoading:Bool = false
    @Published var noMoreData:Bool = false
    
    @Published var threads: [CommonThread] = []
    @Published var models: [CommonViewModel] = []
    
    private var DiscoverId:String = ""
    private var pageNumber: Int = 1
    
    
    init() {
        isLoading = true
        if let LocalDiscoveriesId = LocalDiscoveriesId.getLocalDiscoveriesId(){
            DiscoverId = LocalDiscoveriesId.id!
        }
        print(1)
        initData()

    }
    
    func initData(){
//        let url = "https://media.lifewpg.ca/api/mthreads.v2?page=" + String(pageNumber) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + DiscoverId
         
        let url = baseUrl + "mthreads.v2?page=" + String(pageNumber) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + DiscoverId
        
        print(url)
        
        self.pageNumber += 1
        AF.request(url).responseJSON {[weak self] response in
            
            guard let self = self else { return }
            
            switch response.result{
            case .success(let data):
                let discoverJson = JSON(data)
                let disList = discoverJson["Data"]["pageData"].arrayValue
                if disList.count > 0 {
                    for discover in disList {
                        var thread = CommonThread()
                        let th = discover["thread"]
                        thread.pid = th["pid"].intValue
                        thread.createdAt = th["createdAt"].string!.components(separatedBy: " ")[0]
                        thread.title = th["title"].string ?? ""
                        thread.summary = th["summary"].string ?? ""
                        thread.storeCover = th["storeCover"].string ?? ""
                        thread.storeName = th["storeName"].string ?? ""
                        thread.storeDesc = th["storeDesc"].string ?? ""
                        thread.storeAddress = th["storeAddress"].string ?? ""
                        self.threads.append(thread)
                        self.models.append(CommonViewModel(pid: String(thread.pid)))
                        
                    }
                }else{
                    self.noMoreData = true
                }
                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchData() {
        self.isLoading = true
        
//        let url = "https://media.lifewpg.ca/api/mthreads.v2?page=" + String(pageNumber) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + DiscoverId
        
        let url = baseUrl + "mthreads.v2?page=" + String(pageNumber) + "&perPage=10&filter[sticky]=0&filter[essence]=0&filter[attention]=0&filter[categoryids][0]=" + DiscoverId
        
        self.pageNumber += 1
        
        AF.request(url).responseJSON {[weak self] response in
            
            guard let self = self else { return }
            
            switch response.result{
            case .success(let data):
                let discoverJson = JSON(data)
                let disList = discoverJson["Data"]["pageData"].arrayValue
                if disList.count > 0 {
                    for discover in disList {
                        var thread = CommonThread()
                        let th = discover["thread"]
                        thread.pid = th["pid"].intValue
                        thread.createdAt = th["createdAt"].string!.components(separatedBy: " ")[0]
                        thread.title = th["title"].string ?? ""
                        thread.summary = th["summary"].string ?? ""
                        thread.storeCover = th["storeCover"].string ?? ""
                        thread.storeName = th["storeName"].string ?? ""
                        thread.storeDesc = th["storeDesc"].string ?? ""
                        thread.storeAddress = th["storeAddress"].string ?? ""
                        self.threads.append(thread)
                        self.models.append(CommonViewModel(pid: String(thread.pid)))
                        
                    }
                }else{
                    self.noMoreData = true
                }
                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
            
    }
    
}
