//
//  MerchantsID+CoreDataProperties.swift
//  WinnipegLife
//
//  Created by changming wang on 6/23/21.
//
//

import Foundation
import CoreData


extension MerchantsID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MerchantsID> {
        return NSFetchRequest<MerchantsID>(entityName: "MerchantsID")
    }

    @NSManaged public var name: [String]?
    @NSManaged public var ids: [String]?

}

extension MerchantsID : Identifiable {

}
