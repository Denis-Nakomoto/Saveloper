//
//  PersistenceController.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 09.11.2022.
//

import Foundation
import CoreData

class PersistenceController: ObservableObject {

    // Storage for Core Data
    let container: NSPersistentContainer
    
    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentContainer(name: "Tasks")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        for item in 0..<5 {
            let task = Events(context: controller.container.viewContext)
            task.date = Date()
            task.inOrOut = Bool.random()
            task.favorite = Bool.random()
            task.value = Double(item * 10)
        }
        return controller
    }()

    func save(completion: @escaping(Error?) -> Void = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
            
        }
    }

    func delete(_ object: NSManagedObject, completion: @escaping(Error?) -> Void = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }

    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Events.fetchRequest()
        let batchDeleteRequestEvent = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequestEvent.resultType = .resultTypeObjectIDs
        let batchDeleteEvent = try? container.viewContext.execute(batchDeleteRequestEvent) as? NSBatchDeleteResult
        
        let fetchRequestCategories: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        let batchDeleteRequestCategories = NSBatchDeleteRequest(fetchRequest: fetchRequestCategories)
        batchDeleteRequestCategories.resultType = .resultTypeObjectIDs
        let batchDeleteCategory = try? container.viewContext.execute(
            batchDeleteRequestCategories) as? NSBatchDeleteResult
        
        guard let deleteResultCategory = batchDeleteCategory?.result
            as? [NSManagedObjectID]
            else { return }
        
        guard let deleteResultEvent = batchDeleteEvent?.result
            as? [NSManagedObjectID]
            else { return }
        
        let deletedObjectsCategory: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResultCategory
        ]
        
        let deletedObjectsEvent: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResultEvent
        ]

        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjectsCategory,
            into: [container.viewContext]
        )
        
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjectsEvent,
            into: [container.viewContext]
        )
    }
}
