//
//  SaveloperApp.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import SwiftUI

@main
struct SaveloperApp: App {
    
    @StateObject var persistenceController: PersistenceController
    
    init() {
        _persistenceController = StateObject(wrappedValue: PersistenceController())
    }
    
    var body: some Scene {
        WindowGroup {
            MainConfigurator.configureMainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(persistenceController)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                           perform: save)
        }
    }
    
    func save(_ note: Notification) {
        persistenceController.save()
    }
}
