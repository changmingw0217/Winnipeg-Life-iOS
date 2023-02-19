//
//  CategoryDict+CoreDataClass.swift
//  WinnipegLife
//
//  Created by changming wang on 6/23/21.
//
//

import Foundation
import CoreData

@objc(CategoryDict)
public class CategoryDict: NSManagedObject {
    static func getCategoryDict() -> CategoryDict? {
        let request: NSFetchRequest<CategoryDict> = CategoryDict.fetchRequest()
        return try? CoreDataStack.shared.managedContext.fetch(request).first
    }
    
    static func clearData() {
        guard let CategoryDict = getCategoryDict() else {
            return
        }
        CoreDataStack.shared.managedContext.delete(CategoryDict)
        CoreDataStack.shared.saveContext()
    }
}
