//
//  CommonView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/8/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSoup
import PhoneNumberKit

class CommonViewModel: ObservableObject, Identifiable{
    
    let baseUrl = BaseUrl().url
    
    var id = UUID()
    
    @Published var isLoading: Bool
    
    @Published var viewContent: ViewModel = ViewModel()
    
    @Published var contentImageIndex:[Int] = []
    
    @Published var pid:String
    
    private var categortDict:[String:String] = CategoryDict.getCategoryDict()!.dict!    
    
    init(pid: String) {
        
        self.isLoading = true
        self.pid = pid
//        self.requestData()
//        print("\(self.pid) init")
    }
    
    func requestData() {
//        print(categortDict)
        if !self.isLoading {
            print("\(self.pid) 已加载")
            return
        }
        print("\(self.pid) load data")
        
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
                
                let storeOwnerId = attributes["storeOwnerId"]?.int ?? 0
                self.viewContent.storeOwnerId = String(storeOwnerId)
                
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
                if attachments.count > 2{
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
                            }
                            
                        }else if type == "users"{
                            let attr = item["attributes"]?.dictionary!
                            self.viewContent.userName = attr?["username"]?.string ?? ""
                            self.viewContent.userAvatar = attr?["avatarUrl"]?.string ?? ""
                        }else{
                            continue
                        }
                    }
                }
                
                
                self.isLoading = false
                
            case .failure(let error):
                print(error)
            
            }
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

struct ViewModel: Identifiable{
    var id = UUID()
    var viewCount: String = ""
    var postCount: String = ""
    var viewTitle: String = ""
    var createdAt: String = ""
    var storeName: String = ""
    var storePhone: String = ""
    var formattedPhone: String = ""
    var storeAddress: String = ""
    var storeVideoId: String = ""
    var storeOwnerId:String = ""
    var userName:String = ""
    var userAvatar:String = ""
    var userId:String = ""
    var htmlContent:[[String: String]] = []
    var attachmentsImageUrls:[String] = []
    var attachmentsImageThumbUrls:[String] = []
    var contentImageUrls:[String] = []
    var commentCount: Int = 0
}
