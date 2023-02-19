//
//  User.swift
//  WinnipegLife
//
//  Created by changming wang on 6/5/21.
//

import Foundation

struct UserModel: Codable {
    let id: String
    var username: String
    var avatarUrl: String
    var accessToken:String
    var refreshToken:String
    let email:String
    let tokenType:String
    var unreadNotifications:Int
    var canEditUsername:Bool
    var tokenExpireIn: Date
//    var points: String
}

