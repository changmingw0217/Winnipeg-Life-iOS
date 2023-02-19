//
//  RewardsModel.swift
//  WinnipegLife
//
//  Created by changming wang on 10/26/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class RewardsModel: ObservableObject{
    
    let baseUrl = BaseUrl().url
    
    @Published var rewardPoints: String = "0"
    
    init() {
        checkPoint()
    }
    
    func checkPoint(){
        if let user = UserManager.user {
            
            let url = baseUrl + "users/" + user.id
            
//            let url = "https://media.lifewpg.ca/api/users/" + user.id
            
            let request = AF.request(url)
            
            
            
            request.responseJSON { [weak self] response in
                guard let self = self else { return }
                
                switch response.result{
                case .success(let value):
                    let datas = JSON(value)
                    let data = datas["data"].dictionaryValue
                    
                    let attributes = data["attributes"]!.dictionaryValue
                    
                    let points = attributes["points"]!.stringValue
                    
                    self.rewardPoints = points
                    
                case .failure(let error):
                    if let underlyingError = error.underlyingError {
                        if let urlError = underlyingError as? URLError {
                            switch urlError.code {
                            case .timedOut:
                                print("timeout")
                            case .notConnectedToInternet:
                                print("no internet")
                            default:
                                print("unknown")
                                
                            }
                        }
                    }

                }
            }
            
        }
        
        
    }
}
