//
//  AddEventSheet.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 20.11.2022.
//

import SwiftUI

struct AddEventSheet: View {
    
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let colorsSet = ["#2f4b7c", "#003f5c",
                        "#665191", "#a05195",
                        "#d45087", "#f95d6a",
                        "#ff7c43", "#ffa600"]
    
    @State var selectedCategory: Category?
    
    var body: some View {
        VStack {
            Button("Add event") {
                addEvent()
            }
            .padding()
            SelectCategoryView(value: $selectedCategory)
                .padding()
        }
    }
    
    private func addEvent() {
        let event = Events(context: managedObjectContext)
        if let category = selectedCategory {
            event.category = category
        }
        event.date = Date()
        event.inOrOut = Bool.random()
        event.favorite = Bool.random()
        event.value = Double.random(in: 0...300)
        event.color = colorsSet.randomElement()
        persistenceController.save()
    }
}
