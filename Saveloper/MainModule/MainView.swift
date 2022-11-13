//
//  MainView.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import SwiftUI
import Combine
import CoreData

struct MainView: View {
    
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    var event: FetchRequest<Events>
    var category: FetchRequest<Category>

    private var cancelBag = CancelBag()
    
    init() {
        let request: NSFetchRequest<Events> = Events.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Events.value, ascending: false)
        ]
        event = FetchRequest(fetchRequest: request)
        
        let requestCat: NSFetchRequest<Category> = Category.fetchRequest()
        requestCat.sortDescriptors = [
            NSSortDescriptor(keyPath: \Category.category, ascending: false)
        ]
        category = FetchRequest(fetchRequest: requestCat)
    }
    
    var body: some View {
        ZStack {
            VStack {
                Button("Add event") {
                    addTask()
                }
                Spacer()
            }
            PieChart(pieSlices: createSlices())
            AddEventView(60)
            VStack {
                Spacer()
                ForEach(category.wrappedValue, id: \.self) { cat in
                    Text(cat.category ?? "")
                }
            }
        }
    }
    
    func createSlices() -> [PieSlice] {
        var slices = [PieSlice]()
        event.wrappedValue.enumerated().forEach { (index, data) in
            let value = normalizedValue(index: index, data: event)
            if slices.isEmpty {
                slices.append((.init(startDegree: 0, endDegree: value * 360)))
            } else {
                slices.append(.init(startDegree: slices.last!.endDegree,
                                    endDegree: (value * 360 + slices.last!.endDegree)))
            }
        }
        return slices
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
    

}
