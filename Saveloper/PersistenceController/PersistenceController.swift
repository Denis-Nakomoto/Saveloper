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

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Events.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? container.viewContext.execute(batchDeleteRequest)
        
        let fetchRequestCategories: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        let batchDeleteRequestCategories = NSBatchDeleteRequest(fetchRequest: fetchRequestCategories)
        _ = try? container.viewContext.execute(batchDeleteRequestCategories)
    }
}
