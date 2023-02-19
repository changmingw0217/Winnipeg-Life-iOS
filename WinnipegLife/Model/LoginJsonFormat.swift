// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginJSON = try? newJSONDecoder().decode(LoginJSON.self, from: jsonData)

import Foundation

// MARK: - LoginJSON
struct LoginJSON: Codable {
    let data: LoginJSONData
    let included: [Included]
}

// MARK: - LoginJSONData
struct LoginJSONData: Codable {
    let type, id: String
    let attributes: DataAttributes
    let relationships: Relationships
}

// MARK: - DataAttributes
struct DataAttributes: Codable {
    let tokenType: String
    let expiresIn: Int
    let accessToken, refreshToken: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case status
    }
}

// MARK: - Relationships
struct Relationships: Codable {
    let users: Users
}

// MARK: - Users
struct Users: Codable {
    let data: UsersData
}

// MARK: - UsersData
struct UsersData: Codable {
    let type, id: String
}

// MARK: - Included
struct Included: Codable {
    let type, id: String
    let attributes: IncludedAttributes
}

// MARK: - IncludedAttributes
struct IncludedAttributes: Codable {
    let id: Int
    let username, avatarURL: String
    let isReal: Bool
    let threadCount, followCount, fansCount, likedCount: Int
    let questionCount: Int
    let signature: String
    let usernameBout, status: Int
    let loginAt, joinedAt: String
    let email: String
    let createdAt, updatedAt: String
    let canEdit, canDelete, showGroups: Bool
    let registerReason, banReason: String
    let denyStatus, canEditUsername: Bool

    let unreadNotifications: Int


    enum CodingKeys: String, CodingKey {
        case id, username
        case avatarURL = "avatarUrl"
        case isReal, threadCount, followCount, fansCount, likedCount, questionCount, signature, usernameBout, status, loginAt, joinedAt, email,createdAt, updatedAt, canEdit, canDelete, showGroups, registerReason, banReason, denyStatus, canEditUsername,unreadNotifications
    }
}



