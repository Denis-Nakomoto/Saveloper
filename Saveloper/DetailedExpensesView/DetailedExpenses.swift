//
//  DetailedExpenses.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 19.11.2022.
//

import SwiftUI

struct DetailedExpenses: View {
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)
    ]) var events: FetchedResults<Events>
    @State var category: String
    
    init(_ category: String) {
        _category = .init(wrappedValue: category)
    }
    
    var body: some View {
        VStack {
            Text(category)
                .padding()
            List {
                ForEach(events, id: \.date) { event in
                    HStack {
                        Text("\(event.date ?? Date())")
                            .padding()
                        Text("\(event.value)")
                            .padding()
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}
