//
//  foodNames+CoreDataProperties.swift
//  WinnipegLife
//
//  Created by changming wang on 8/19/21.
//
//

import Foundation
import CoreData


extension foodNames {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<foodNames> {
        return NSFetchRequest<foodNames>(entityName: "FoodId")
    }

    @NSManaged public var ids: [String]?
    @NSManaged public var name: [String]?

}

extension foodNames : Identifiable {

}
