//
//  AddCategorySheet.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 20.11.2022.
//

import SwiftUI

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
