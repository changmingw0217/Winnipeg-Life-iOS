//
//  CommunityID+CoreDataClass.swift
//  WinnipegLife
//
//  Created by changming wang on 6/26/21.
//
//

import Foundation
import CoreData

@objc(CommunityID)
public class CommunityID: NSManagedObject {
    static func getCommunityID() -> CommunityID? {
        let request: NSFetchRequest<CommunityID> = CommunityID.fetchRequest()
        return try? CoreDataStack.shared.managedContext.fetch(request).first
    }
    
    static func clearData() {
        guard let CommunityID = getCommunityID() else {
            return
        }
        CoreDataStack.shared.managedContext.delete(CommunityID)
        CoreDataStack.shared.saveContext()
    }
}
