//
//  AddEventViewModel.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 20.11.2022.
//

import SwiftUI

class AddEventViewModel: ObservableObject {
    
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Published var animate = false
    @Published var radius: CGFloat
    
    init(_ radius: CGFloat) {
        _radius = .init(initialValue: radius)
    }
    
    func animateToggle() {
        withAnimation(.spring().speed(2)) {
            animate.toggle()
        }
    }
    
    func delete(at index: Int, categories: FetchedResults<Category>) {
        let category = categories[index]
        managedObjectContext.delete(category)
        try? managedObjectContext.save()
    }
    
    func calculateIconPosition(categories: FetchedResults<Category>) -> [CategoryVector] {
        if !categories.isEmpty {
            let baseAngle = CGFloat(360 / categories.count)
            let halfAngle = CGFloat(baseAngle / 2)
            var returnValue: [CategoryVector] = []
            var counter: CGFloat = 1
            for category in categories {
                var xCoordinate: CGFloat = 0
                var yCoordinate: CGFloat = 0
                let currentAngle = baseAngle * counter
                if (0..<90).contains(currentAngle - halfAngle) {
                    xCoordinate = cos((currentAngle - halfAngle) * Double.pi / 180) * radius
                    yCoordinate = -sin((currentAngle - halfAngle) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCoordinate, yCoordinate: yCoordinate,
                                                      category: category.category.orEmpty,
                                                      objectId: category.objectID))
                }
                
                if (90..<180).contains(currentAngle - halfAngle) && categories.count != 3 {
                    let alpha = CGFloat(180) - currentAngle
                    xCoordinate = -cos((alpha + halfAngle) * Double.pi / 180) * radius
                    yCoordinate = -sin((alpha + halfAngle) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCoordinate, yCoordinate: yCoordinate,
                                                      category: category.category.orEmpty,
                                                      objectId: category.objectID))
                }
                
                if currentAngle - halfAngle == 180 && categories.count == 3 {
                    let alpha = CGFloat(180) - currentAngle
                    xCoordinate = -cos((alpha + halfAngle) * Double.pi / 180) * radius
                    yCoordinate = -sin((alpha + halfAngle) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCoordinate, yCoordinate: yCoordinate,
                                                      category: category.category.orEmpty,
                                                      objectId: category.objectID))
                }
                
                if currentAngle - halfAngle == 180 && categories.count != 3 {
                    let alpha = currentAngle - halfAngle
                    xCoordinate = cos((alpha) * Double.pi / 180) * radius
                    yCoordinate = -sin((alpha) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCoordinate, yCoordinate: yCoordinate,
                                                      category: category.category.orEmpty,
                                                      objectId: category.objectID))
                }
                
                if (181..<270).contains(currentAngle - halfAngle) {
                    let alpha = currentAngle - halfAngle
                    xCoordinate = cos((alpha) * Double.pi / 180) * radius
                    yCoordinate = -sin((alpha) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCoordinate, yCoordinate: yCoordinate,
                                                      category: category.category.orEmpty,
                                                      objectId: category.objectID))
                }
                
                if (270..<360).contains(currentAngle - halfAngle) {
                    let alpha = CGFloat(360) - currentAngle
                    xCoordinate = cos((alpha + halfAngle) * Double.pi / 180) * radius
                    yCoordinate = sin((alpha + halfAngle) * Double.pi / 180) * radius
                    returnValue.append(CategoryVector(xCoordinate: xCoordinate, yCoordinate: yCoordinate,
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
