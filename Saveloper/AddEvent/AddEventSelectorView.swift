//
//  AddEventSelectorView.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 11.11.2022.
//

import SwiftUI

struct AddEventSelectorView: View {
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.category)
    ]) var categories: FetchedResults<Category>
    
    @StateObject var addEventViewModel: AddEventViewModel
    
    init(_ radius: CGFloat) {
        _addEventViewModel = .init(wrappedValue: AddEventViewModel(radius))
    }
    
    var body: some View {
        ZStack {
            Circle()
                .scale(addEventViewModel.animate ? 1.0 : 0.2)
                .foregroundColor(Color.fadeBlackColor)
                .frame(width: addEventViewModel.radius*6)
            ForEach(addEventViewModel.calculateIconPosition(categories: categories),
                    id: \.self) { item in
                CircluarMenuButtonItem(imageName: item.category, handler: { _ in
                    let index = addEventViewModel.calculateIconPosition(
                        categories: categories).firstIndex(of: item)
                    addEventViewModel.animateToggle()
                    addEventViewModel.delete(at: index ?? 0, categories: categories)
                })
                .frame(width: addEventViewModel.radius/2)
                .offset(x: addEventViewModel.animate ? item.xCoordinate*2.5 : 0,
                        y: addEventViewModel.animate ? item.yCoordinate*2.5 : 0)
            }
            Circle()
                .scale(addEventViewModel.animate ? 1.0 : 0.8)
                .foregroundColor(.white)
                .frame(width: addEventViewModel.radius)
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(width: addEventViewModel.radius/2)
                .rotationEffect(.degrees(addEventViewModel.animate ? 45 : 0))
        }.onTapGesture {
            addEventViewModel.animateToggle()
        }
    }
}
