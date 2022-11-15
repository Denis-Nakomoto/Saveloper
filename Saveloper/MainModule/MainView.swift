//
//  MainView.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import SwiftUI
import Combine
import CoreData

// Github token
// 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

struct MainView: View {
    
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        ZStack {
            VStack {
                Button("Add event") {
                    addTask()
                }
                Button("DeleteAll events") {
                    deleteAll()
                }
                Spacer()
            }
            PieChart()
            AddEventView(60)
        }
    }
    
    func addTask() {
        let event = Events(context: managedObjectContext)
        let category = Category(context: managedObjectContext)
        category.category = "person"
        event.date = Date()
        event.inOrOut = Bool.random()
        event.favorite = Bool.random()
        event.value = Double.random(in: 0...300)
        event.category = category
        persistenceController.save()
    }
    
    func deleteAll() {
        persistenceController.deleteAll()
    }
    
    func deleteEvent(object: NSObject) {
        persistenceController.deleteAll()
    }
}
