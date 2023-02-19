//
//  CategoryDict+CoreDataProperties.swift
//  WinnipegLife
//
//  Created by changming wang on 6/23/21.
//
//

import Foundation
import CoreData


extension CategoryDict {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryDict> {
        return NSFetchRequest<CategoryDict>(entityName: "CategoryDict")
    }

    @NSManaged public var dict: [String:String]?

}

extension CategoryDict : Identifiable {

}
