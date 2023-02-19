//
//  UserManager.swift
//  WinnipegLife
//
//  Created by changming wang on 6/7/21.
//

import Foundation

struct UserManager {
    static var user: UserModel? = {
        guard let data = UserDefaults.standard.data(forKey: "UserInfoKey") else {
            return nil
        }
        return try? JSONDecoder().decode(UserModel.self, from: data)
    }()
    
    static func saveUser(user: UserModel) {
        UserDefaults.standard.set( try? JSONEncoder().encode(user), forKey:  "UserInfoKey")
    }
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: "UserInfoKey")
    }
}
