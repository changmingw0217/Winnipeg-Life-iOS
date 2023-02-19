//
//  CommonThreadModel.swift
//  WinnipegLife
//
//  Created by changming wang on 6/10/21.
//

import Foundation


struct CommonThread: Codable, Hashable, Identifiable{
    var id = UUID()
    var pid: Int = 0
    var title: String = ""
    var summary: String = ""
    var createdAt:String = ""
    var diffCreatedAt:String = ""
    var categoryId:String = ""
    var storeCover: String = ""
    var storeName: String = ""
    var storeDesc: String = ""
    var storeAddress: String = ""
    var storeId:String = ""
    var viewCount: Int = 0
    var userName:String = ""
    var userAvatar:String = ""
    var imageUrls:[String] = []
}

struct SearchThread:Codable, Hashable, Identifiable {
    var id = UUID()
    var pid: Int = 0
    var title:String = ""
    var createdAt:String = ""
    var viewCount:Int = 0
    var postCount:Int = 0
    var userId:String = ""
    var userName:String = ""
    var userAvatar:String = ""
    var categoriesID:String = ""
    var categoryName:String = ""
}
