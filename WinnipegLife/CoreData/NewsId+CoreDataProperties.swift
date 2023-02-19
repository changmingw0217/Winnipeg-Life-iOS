//
//  NewsId+CoreDataProperties.swift
//  
//
//  Created by changming wang on 6/9/21.
//
//

import Foundation
import CoreData


extension NewsId {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsId> {
        return NSFetchRequest<NewsId>(entityName: "NewsId")
    }

    @NSManaged public var ids: [String]?
    @NSManaged public var name: [String]?

}
