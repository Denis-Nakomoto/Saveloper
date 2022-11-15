//
//  AddEventView.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 11.11.2022.
//

import SwiftUI
import CoreData

struct AddEventView: View {

    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var radius: CGFloat
    @State private var animate = false
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.category)
    ]) var categories: FetchedResults<Category>
    
    init(_ radius: CGFloat) {
        _radius = .init(initialValue: radius)
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//        request.sortDescriptors = [
//            NSSortDescriptor(keyPath: \Category.category, ascending: false)
//        ]
//        categories = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .scale(animate ? 1.0 : 0.2)
                .foregroundColor(Color.fadeBlackColor)
                .frame(width: radius*6)
            ForEach(calculateIconPosition(), id: \.self) { item in
                CircluarMenuButtonItem(imageName: item.category, handler: { _ in
                    let index = calculateIconPosition().firstIndex(of: item)
                    animateToggle()
                    delete(at: index ?? 0)
                })
                    .frame(width: radius/2)
                    .offset(x: animate ? item.xCoordinate*2.5 : 0, y: animate ? item.yCoordinate*2.5 : 0)
            }
            Circle()
                .scale(animate ? 1.0 : 0.8)
                .foregroundColor(.white)
                .frame(width: radius)
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(width: radius/2)
                .rotationEffect(.degrees(animate ? 45 : 0))
        }.onTapGesture {
            animateToggle()
        }
    }
    
    private func animateToggle() {
        withAnimation(.spring().speed(2)) {
            animate.toggle()
        }
    }
    
    private func delete(at index: Int) {
        let category = categories[index]
        managedObjectContext.delete(category)
        try? managedObjectContext.save()
    }
    
    private func calculateIconPosition() -> [CategoryVector] {
        if !categories.isEmpty {
            let baseAngle = CGFloat(360 / categories.count)
            let halfAngle = CGFloat(baseAngle / 2)
            var returnValue: [CategoryVector] = []
            var counter: CGFloat = 1
            for category in categories {
                var xCordinate: CGFloat = 0
                var yCoordinate: CGFloat = 0
                let currentAngle = baseAngle * counter
                if (0..<90).contains(currentAngle - halfAngle) {
                    xCordinate = cos((currentAngle - halfAngle) * Double.pi / 180) * radius
                    yCoordinate = -sin((currentAngle - halfAngle) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCordinate, yCoordinate: yCoordinate,
                                                      category: category.category.orEmpty,
                                                      objectId: category.objectID))
                }
                if (90..<180).contains(currentAngle - halfAngle) {
                    let alpha = CGFloat(180) - currentAngle
                    xCordinate = -cos((alpha + halfAngle) * Double.pi / 180) * radius
                    yCoordinate = -sin((alpha + halfAngle) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCordinate, yCoordinate: yCoordinate,
                                                      category: category.category.orEmpty,
                                                      objectId: category.objectID))
                }
                if (180..<270).contains(currentAngle - halfAngle) {
                    let alpha = CGFloat(270) - currentAngle
                    xCordinate = -cos((alpha + halfAngle) * Double.pi / 180) * radius
                    yCoordinate = sin((alpha + halfAngle) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCordinate, yCoordinate: yCoordinate,
                                                      category: category.category.orEmpty,
                                                      objectId: category.objectID))
                }
                if (270...360).contains(currentAngle - halfAngle) {
                    let alpha = CGFloat(360) - currentAngle
                    xCordinate = cos((alpha + halfAngle) * Double.pi / 180) * radius
                    yCoordinate = sin((alpha + halfAngle) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCordinate, yCoordinate: yCoordinate,
                                                      category: category.category.orEmpty,
                                                      objectId: category.objectID))
                }
                counter += 1
            }
            return returnValue
        } else {
            return []
        }
    }
}

struct CategoryVector: Hashable {
    var xCoordinate: CGFloat = 0
    var yCoordinate: CGFloat = 0
    var category = ""
    var objectId: NSManagedObjectID = NSManagedObjectID()
}

private struct CircluarMenuButtonItem: View {
    @State var imageName: String
    var handler: (String) -> Void
    var body: some View {
        Button {
            print("\(imageName) clicked")
            handler(imageName)
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
        }
    }
}
