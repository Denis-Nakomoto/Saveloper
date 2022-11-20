//
//  MainView.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var pieChartViewModel = PieChartViewModel()
    
    @State var selectedPickerIndex = 0
    @State var addCategorySheet = false
    @State var addEventSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedPickerIndex) {
                    Text("Day").tag(0)
                    Text("Month").tag(1)
                    Text("Year").tag(2)
                    Text("Custom").tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 60)
                .padding(.vertical, 20)
                ZStack {
                    VStack {
                        Button("Add category") {
                            addCategorySheet.toggle()
                        }
                        .padding()
                        Button("Add events") {
                            addEventSheet.toggle()
                        }
                        .padding()
                        Button("DeleteAll events") {
                            deleteAll()
                        }
                        .padding()
                        Spacer()
                    }
                    PieChart(pieChartViewModel)
                    AddEventView(60)
                    NavigationLink(
                        destination: DetailedExpenses(pieChartViewModel.selectedEvent?.category?.category ?? ""
                                                     ), isActive: $pieChartViewModel.showDetailedEvent) {
                                                         Text("")
                                                     }
                }
            }
            .halfSheet(showSheet: $addCategorySheet, sheetView: {
                AddCategorySheet()
                    .inject(persistenceController)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            })
            .halfSheet(showSheet: $addEventSheet, sheetView: {
                AddEventSheet()
                    .inject(persistenceController)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            })
        }
    }
    
    func deleteAll() {
        persistenceController.deleteAll()
    }
    
}

struct AddCategorySheet: View {
    
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var selectedCategory: String?
    
    let categories = ["person", "pin", "divide.circle", "bicycle.circle"]
    
    var body: some View {
        VStack {
            Button("Add category") {
                if selectedCategory != nil {
                    addCategory()
                }
                selectedCategory = nil
            }
            .padding()
            AddCategoryView(value: $selectedCategory)
                .padding()
        }
    }
    
    private func addCategory() {
        let category = Category(context: managedObjectContext)
        category.category = selectedCategory
        persistenceController.save()
    }
}

struct AddEventSheet: View {
    
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    
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
        persistenceController.save()
    }
}
