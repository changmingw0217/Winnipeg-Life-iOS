//
//  CommunityID+CoreDataProperties.swift
//  WinnipegLife
//
//  Created by changming wang on 6/26/21.
//
//

import Foundation
import CoreData


extension CommunityID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommunityID> {
        return NSFetchRequest<CommunityID>(entityName: "CommunityID")
    }

    @NSManaged public var ids: [String]?
    @NSManaged public var name: [String]?

}

extension CommunityID : Identifiable {

}
