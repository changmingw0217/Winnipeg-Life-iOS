//
//  ClubID+CoreDataClass.swift
//  WinnipegLife
//
//  Created by changming wang on 8/28/21.
//
//

import Foundation
import CoreData

@objc(ClubID)
public class ClubID: NSManagedObject {
    static func getClubID() -> ClubID? {
        let request: NSFetchRequest<ClubID> = ClubID.fetchRequest()
        return try? CoreDataStack.shared.managedContext.fetch(request).first
    }
    
    static func clearData() {
        guard let ClubID = getClubID() else {
            return
        }
        CoreDataStack.shared.managedContext.delete(ClubID)
        CoreDataStack.shared.saveContext()
    }
}
