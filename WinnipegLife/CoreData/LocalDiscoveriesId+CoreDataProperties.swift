//
//  LocalDiscoveriesId+CoreDataProperties.swift
//  WinnipegLife
//
//  Created by changming wang on 6/15/21.
//
//

import Foundation
import CoreData


extension LocalDiscoveriesId {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalDiscoveriesId> {
        return NSFetchRequest<LocalDiscoveriesId>(entityName: "LocalDiscoveriesId")
    }

    @NSManaged public var id: String?

}

extension LocalDiscoveriesId : Identifiable {

}
