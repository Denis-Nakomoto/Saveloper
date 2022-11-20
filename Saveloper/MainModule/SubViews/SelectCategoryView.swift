//
//  SelectCategory.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 18.11.2022.
//

import SwiftUI

struct SelectCategoryView: View {
    
    @Binding var value: Category?
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.category)
    ]) var categories: FetchedResults<Category>
    
    var placeholder = "Select category"
    
    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(category.category.orEmpty) {
                    value = category
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
