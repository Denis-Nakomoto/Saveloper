//
//  SelectCategory.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 18.11.2022.
//

import SwiftUI
import CoreData

struct SelectCategory: View {
    @Binding var value: Category?
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.category)
    ]) var categories: FetchedResults<Category>
    
    var placeholder = "Select Client"
    
    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(category.category.orEmpty) {
                    self.value = category
                }
            }
        } label: {
            VStack(spacing: 5) {
                HStack {
                    Text(value == nil ? placeholder : value?.category ?? "")
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
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
