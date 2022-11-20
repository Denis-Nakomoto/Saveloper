//
//  MainView.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var persistenceController: PersistenceController
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
                    AddEventSelectorView(60)
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
