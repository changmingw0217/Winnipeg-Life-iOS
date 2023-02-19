//
//  ReplyModel.swift
//  WinnipegLife
//
//  Created by changming wang on 8/1/21.
//

import Foundation

// MARK: - ReplyModel
struct ReplyModel: Codable {
    var data: ReplyDataClass?
}

// MARK: - DataClass
struct ReplyDataClass: Codable {
    var type = "posts"
    var relationships: ReplyRelationships?
    var attributes: ReplyAttributes?
}

// MARK: - Attributes
struct ReplyAttributes: Codable {
    var isComment: Bool?
    var replyID, content: String?

    enum CodingKeys: String, CodingKey {
        case isComment
        case replyID = "replyId"
        case content
    }
}

// MARK: - Relationships
struct ReplyRelationships: Codable {
    var thread: ReplyThread?
    var attachments: ReplyAttachments?
}

// MARK: - Attachments
struct ReplyAttachments: Codable {
    var data: [ReplyDAT]?
}

// MARK: - DAT
struct ReplyDAT: Codable {
    var id, type: String?
}

// MARK: - Thread
struct ReplyThread: Codable {
    var data: ReplyDAT?
}
