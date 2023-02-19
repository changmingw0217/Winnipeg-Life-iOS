//
//  ClubID+CoreDataProperties.swift
//  WinnipegLife
//
//  Created by changming wang on 8/28/21.
//
//

import Foundation
import CoreData


extension ClubID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClubID> {
        return NSFetchRequest<ClubID>(entityName: "ClubID")
    }

    @NSManaged public var ids: [String]?
    @NSManaged public var name: [String]?

}

extension ClubID : Identifiable {

}
