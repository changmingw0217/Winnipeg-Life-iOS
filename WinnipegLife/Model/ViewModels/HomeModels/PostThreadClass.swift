//
//  SendThreadModel.swift
//  WinnipegLife
//
//  Created by changming wang on 8/11/21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sendThreadModel = try? newJSONDecoder().decode(SendThreadModel.self, from: jsonData)

import Foundation

// MARK: - SendThreadModel
struct PostThreadModel: Codable {
    var data: PostThreadModelData?
}

// MARK: - SendThreadModelData
struct PostThreadModelData: Codable {
    var type = "threads"
    var relationships: PostThreadRelationships?
    var attributes: PostThreadAttributes?
}

// MARK: - Attributes
struct PostThreadAttributes: Codable {
    var content, type: String?
    var price, freeWords, attachmentPrice: Int?
    var location, latitude, longitude: String?

    enum CodingKeys: String, CodingKey {
        case content, type, price
        case freeWords = "free_words"
        case attachmentPrice = "attachment_price"
        case location, latitude, longitude
    }
}

// MARK: - Relationships
struct PostThreadRelationships: Codable {
    var category: PostThreadCategory?
    var attachments: PostThreadAttachments?
}

// MARK: - Attachments
struct PostThreadAttachments: Codable {
    var data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    var id, type: String?
}

// MARK: - Category
struct PostThreadCategory: Codable {
    var data: PostThreadCategoryData?
}

// MARK: - CategoryData
struct PostThreadCategoryData: Codable {
    var type: String?
    var id: Int?
}
