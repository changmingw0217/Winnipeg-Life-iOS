//
//  NewsId+CoreDataClass.swift
//  
//
//  Created by changming wang on 6/9/21.
//
//

import Foundation
import CoreData

@objc(NewsId)
public class NewsId: NSManagedObject {
    static func getNewsId() -> NewsId? {
        let request: NSFetchRequest<NewsId> = NewsId.fetchRequest()
        return try? CoreDataStack.shared.managedContext.fetch(request).first
    }
    
    static func clearData() {
        guard let newsId = getNewsId() else {
            return
        }
        CoreDataStack.shared.managedContext.delete(newsId)
        CoreDataStack.shared.saveContext()
    }
}
