//
//  AppModel.swift
//  WinnipegLife
//
//  Created by changming wang on 6/7/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class AppModel: ObservableObject{
    
    @Published var user: UserModel?
    
    init() {
        self.user = UserManager.user
    }
    
}
