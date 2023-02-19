//
//  foodNames+CoreDataClass.swift
//  WinnipegLife
//
//  Created by changming wang on 8/19/21.
//
//

import Foundation
import CoreData

@objc(foodNames)
public class foodNames: NSManagedObject {
    static func getFoodId() -> foodNames? {
        let request: NSFetchRequest<foodNames> = foodNames.fetchRequest()
        return try? CoreDataStack.shared.managedContext.fetch(request).first
    }
    
    static func clearData() {
        guard let FoodId = getFoodId() else {
            return
        }
        CoreDataStack.shared.managedContext.delete(FoodId)
        CoreDataStack.shared.saveContext()
    }
}
