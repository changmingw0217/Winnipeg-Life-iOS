//
//  LocalDiscoveriesId+CoreDataClass.swift
//  WinnipegLife
//
//  Created by changming wang on 6/15/21.
//
//

import Foundation
import CoreData

@objc(LocalDiscoveriesId)
public class LocalDiscoveriesId: NSManagedObject {
    static func getLocalDiscoveriesId() -> LocalDiscoveriesId? {
        let request: NSFetchRequest<LocalDiscoveriesId> = LocalDiscoveriesId.fetchRequest()
        return try? CoreDataStack.shared.managedContext.fetch(request).first
    }
    
    static func clearData() {
        guard let LocalDiscoveriesId = getLocalDiscoveriesId() else {
            return
        }
        CoreDataStack.shared.managedContext.delete(LocalDiscoveriesId)
        CoreDataStack.shared.saveContext()
    }
}
