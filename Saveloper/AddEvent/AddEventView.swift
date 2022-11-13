//
//  AddEventView.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 11.11.2022.
//

import SwiftUI
import CoreData

struct AddEventView: View {
    @State var radius: CGFloat
    @State private var animate = false
    
    var categories: FetchRequest<Category>
    
    init(_ radius: CGFloat) {
        _radius = .init(initialValue: radius)
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Category.category, ascending: false)
        ]
        categories = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .scale(animate ? 1.0 : 0.2)
                .foregroundColor(Color.fadeBlackColor)
                .frame(width: radius*6)
            ForEach(calculateIconPosition(), id: \.self) { item in
                CircluarMenuButtonItem(imageName: item.category, handler: { _ in
                    animateToggle()
                })
                    .frame(width: radius/2)
                    .offset(x: animate ? item.x*2.5 : 0, y: animate ? item.y*2.5 : 0)
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
    
    private func calculateIconPosition() -> [CategoryVector] {
        let baseAngle = CGFloat(360 / categories.wrappedValue.count)
        let halfAngle = CGFloat(baseAngle / 2)
        var returnValue: [CategoryVector] = []
        var counter: CGFloat = 1
        for category in categories.wrappedValue {
            var x:CGFloat = 0
            var y:CGFloat = 0
            let currentAngle = baseAngle * counter
            if (0..<90).contains(currentAngle - halfAngle) {
                x = cos((currentAngle - halfAngle) * Double.pi / 180) * radius
                y = -sin((currentAngle - halfAngle) * Double.pi / 180) * radius
                returnValue.append(CategoryVector(x: x, y: y,
                                                  category: category.category.orEmpty))
            }
            if (90..<180).contains(currentAngle - halfAngle) {
                let alpha = CGFloat(180) - currentAngle
                x = -cos((alpha + halfAngle) * Double.pi / 180) * radius
                y = -sin((alpha + halfAngle) * Double.pi / 180) * radius
                returnValue.append(CategoryVector(x: x, y: y,
                                                  category: category.category.orEmpty))
            }
            if (180..<270).contains(currentAngle - halfAngle) {
                let alpha = CGFloat(270) - currentAngle
                x = -cos((alpha + halfAngle) * Double.pi / 180) * radius
                y = sin((alpha + halfAngle) * Double.pi / 180) * radius
                returnValue.append(CategoryVector(x: x, y: y,
                                                  category: category.category.orEmpty))
            }
            if (270...360).contains(currentAngle - halfAngle) {
                let alpha = CGFloat(360) - currentAngle
                x = cos((alpha + halfAngle) * Double.pi / 180) * radius
                y = sin((alpha + halfAngle) * Double.pi / 180) * radius
                returnValue.append(CategoryVector(x: x, y: y,
                                                  category: category.category.orEmpty))
            }
            counter += 1
        }
        return returnValue
    }
}

struct CategoryVector: Hashable {
    var x: CGFloat = 0
    var y: CGFloat = 0
    var category = ""
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

let sinus = sin(90.0 * Double.pi / 180)

let cosinus = cos(90 * Double.pi / 180)
