//
//  MerchantsID+CoreDataClass.swift
//  WinnipegLife
//
//  Created by changming wang on 6/23/21.
//
//

import Foundation
import CoreData

@objc(MerchantsID)
public class MerchantsID: NSManagedObject {
    static func getMerchantsID() -> MerchantsID? {
        let request: NSFetchRequest<MerchantsID> = MerchantsID.fetchRequest()
        return try? CoreDataStack.shared.managedContext.fetch(request).first
    }
    
    static func clearData() {
        guard let MerchantsID = getMerchantsID() else {
            return
        }
        CoreDataStack.shared.managedContext.delete(MerchantsID)
        CoreDataStack.shared.saveContext()
    }
}
