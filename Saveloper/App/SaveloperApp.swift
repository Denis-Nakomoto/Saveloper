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
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        _persistenceController = StateObject(wrappedValue: PersistenceController())
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(persistenceController)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                persistenceController.save()
            case .inactive:
                print("Scene is inactive")
            case .active:
                print("Scene is active")
            @unknown default:
                print("Apple must have changes somethig")
            }
        }
    }
}
