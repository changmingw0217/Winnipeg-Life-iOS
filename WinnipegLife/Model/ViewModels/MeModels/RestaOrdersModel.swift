//
//  File.swift
//  WinnipegLife
//
//  Created by changming wang on 9/20/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI

class RestaOrders: ObservableObject{
    
    @Published var orders:[RestaOrder] = [];
    
    @Published var isLoading:Bool = false
    
    @Published var isLoadingMore:Bool = false
    
    @Published var timeoutAlert: Bool = false
    @Published var noInternetAlert: Bool = false
    @Published var unknownError:Bool = false
    
    @Published var noMore:Bool = false
    
    private var userId:String
    
    private var page:Int = 1
    
    init(userId: String) {
        self.userId = userId
//        fetchData()
    }
    
    func fetchData() {
        
        let url = "https://media.lifewpg.ca/api/rdio/customerorders?customer_id=" + self.userId + "&page=" + String(page) + "&per_page=10"
        
        self.page += 1
        
        self.isLoading = true
        
        AF.request(url).responseJSON {[weak self] response in
            
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let list = json["data"].arrayValue
                
                for order in list {
                    let attr = order["attributes"].dictionaryValue
                    var detail = RestaOrder()
                    
                    let id = attr["id"]?.intValue
                    detail.pid = id!
                    
                    let time = self.formatDate(dateStr: attr["dining_time"]!.stringValue)
                    detail.time = time
                    
                    let num = attr["dining_num"]?.intValue
                    detail.numberOfPeople = String(num!)
                    
                    let name = attr["store_name"]!.stringValue
                    
                    detail.storeName = name
                    
                    let cover = attr["store_cover"]!.stringValue
                    
                    detail.storeCover = cover
                    
                    let status = attr["status"]?.intValue
                    if status == 1 {
                        detail.status = orderStatus.pending
                        detail.color = Color.yellow
                    }else if status == 2 {
                        detail.status = orderStatus.confirmed
                        detail.color = Color.orange
                    }else if status == 3 {
                        detail.status = orderStatus.needReview
                        detail.color = Color.systemPink
                    }else if status == 4 {
                        detail.status = orderStatus.reviewed
                        detail.color = Color.green
                    }else if status == 255 {
                        detail.status = orderStatus.canceled
                        detail.color = Color.red
                    }else{
                        detail.status = orderStatus.unknown
                        detail.color = Color.gray
                    }
                    
                    self.orders.append(detail)
                }
                
                self.isLoading = false
                print(self.orders)
                
            case .failure(let error):
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .timedOut:
//                            self.showLoadingIndicator.toggle()
                            self.timeoutAlert.toggle()
                            self.isLoading = false
                        case .notConnectedToInternet:
//                            self.showLoadingIndicator.toggle()
                            self.noInternetAlert.toggle()
                            self.isLoading = false
                        default:
                            //Do something
//                            self.showLoadingIndicator.toggle()
                            self.unknownError.toggle()
                            self.isLoading = false
                            
                        }
                    }
                }

            }
        }
    
    }
    
    func fetchMore() {
        
        let url = "https://media.lifewpg.ca/api/rdio/customerorders?customer_id=" + self.userId + "&page=" + String(page) + "&per_page=5&status=1"
        
        self.page += 1
        
        self.isLoadingMore = true
        
        AF.request(url).responseJSON {[weak self] response in
            
            guard let self = self else { return }
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let list = json["data"].arrayValue
                
                if list.count > 0 {
                    for order in list {
                        let attr = order["attributes"].dictionaryValue
                        var detail = RestaOrder()
                        
                        let id = attr["id"]?.intValue
                        detail.pid = id!
                        
                        let time = self.formatDate(dateStr: attr["dining_time"]!.stringValue)
                        detail.time = time
                        
                        let num = attr["dining_num"]?.intValue
                        detail.numberOfPeople = String(num!)
                        
                        let name = attr["store_name"]!.stringValue
                        
                        detail.storeName = name
                        
                        let cover = attr["store_cover"]!.stringValue
                        
                        detail.storeCover = cover
                        
                        let status = attr["status"]?.intValue
                        if status == 1 {
                            detail.status = orderStatus.pending
                            detail.color = Color.yellow
                        }else if status == 2 {
                            detail.status = orderStatus.confirmed
                            detail.color = Color.orange
                        }else if status == 3 {
                            detail.status = orderStatus.needReview
                            detail.color = Color.systemPink
                        }else if status == 4 {
                            detail.status = orderStatus.reviewed
                            detail.color = Color.green
                        }else if status == 255 {
                            detail.status = orderStatus.canceled
                            detail.color = Color.red
                        }else{
                            detail.status = orderStatus.unknown
                            detail.color = Color.gray
                        }
                        
                        
                        
                        self.orders.append(detail)
                    }
                }else{
                    self.noMore = true
                }
                
                self.isLoadingMore = false
//                print(self.orders)
                
            case .failure(let error):
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .timedOut:
//                            self.showLoadingIndicator.toggle()
                            self.timeoutAlert.toggle()
                            self.isLoadingMore = false
                        case .notConnectedToInternet:
//                            self.showLoadingIndicator.toggle()
                            self.noInternetAlert.toggle()
                            self.isLoadingMore = false
                        default:
                            //Do something
//                            self.showLoadingIndicator.toggle()
                            self.unknownError.toggle()
                            
                            self.isLoadingMore = false
                        }
                    }
                }

            }
        }
    
    }
    
    private func formatDate(dateStr:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

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

struct RestaOrder: Identifiable{
    var id = UUID()
    var pid: Int = 0
    var time: String = ""
    var numberOfPeople:String = ""
    var color:Color = Color.blue
    var status: orderStatus = orderStatus.pending
    var storeName: String = ""
    var storeCover:String = ""
    
}

enum orderStatus: LocalizedStringKey{
    case pending = "Pending"
    case confirmed = "Confirmed"
    case needReview = "Need Review"
    case reviewed = "Reviewed"
    case canceled = "Cenceled"
    case unknown = "unknown"
}


