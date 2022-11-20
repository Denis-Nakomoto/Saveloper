//
//  AddCategoryView.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 20.11.2022.
//

import SwiftUI

struct AddCategoryView: View {
    
    @Binding var value: String?
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.category)
    ]) var categories: FetchedResults<Category>
    
    var placeholder = "Select category"
    let possibleCategories = ["person", "pin", "divide.circle", "bicycle.circle"]
    
    var body: some View {
        Menu {
            ForEach(filterCategory(), id: \.self) { category in
                Button("\(category)") {
                    value = category
                }
            }
        } label: {
            VStack(spacing: 5) {
                HStack {
                    Text(value == nil ? placeholder : value.orEmpty)
                        .foregroundColor(value == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.orange)
                        .font(Font.system(size: 20, weight: .bold))
                }
                .padding(.horizontal)
                Rectangle()
                    .fill(Color.orange)
                    .frame(height: 2)
            }
        }
    }
    
    private func filterCategory() -> [String] {
        var returnCategories = possibleCategories
        for category in possibleCategories {
            if categories.contains(where: { $0.category == category }) {
                if let itemToRemoveIndex = returnCategories.firstIndex(where: { $0 == category }) {
                    returnCategories.remove(at: itemToRemoveIndex)
                }
            }
        }
        return returnCategories
    }
}
