//
//  PieChart.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 10.11.2022.
//

import SwiftUI
import CoreData

struct PieChart: View {
    
    let accentColors = [
         Color.init(hex: "#2f4b7c"),
         Color.init(hex: "#003f5c"),
         Color.init(hex: "#665191"),
         Color.init(hex: "#a05195"),
         Color.init(hex: "#d45087"),
         Color.init(hex: "#f95d6a"),
         Color.init(hex: "#ff7c43"),
         Color.init(hex: "#ffa600")
     ]

    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGPoint = .init(x: -1, y: -1)
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)
    ]) var events: FetchedResults<Events>

    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(createSlices(), id: \.self) { item in
                            PieChartSlice(center: CGPoint(x: geometry.frame(in: .local).midX,
                                                          y: geometry.frame(in: .local).midY),
                                          radius: geometry.frame(in: .local).width/2,
                                          startDegree: item.startDegree,
                                          endDegree: item.endDegree,
                                          isTouched: sliceIsTouched(slice: item,
                                                                    inPie: geometry.frame(in: .local)),
                                          accentColor: accentColors.randomElement() ?? .white,
                                          separatorColor: .white)
                        }
                    }
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ position in
                            let pieSize = geometry.frame(in: .local)
                            touchLocation   =   position.location
                            updateCurrentValue(inPie: pieSize)
                        })
                            .onEnded({ _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(Animation.easeOut) {
                                        resetValues()
                                    }
                                }
                            })
                    )
                }
                .aspectRatio(contentMode: .fit)
                VStack {
                    if !currentLabel.isEmpty {
                        Text(currentLabel)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.black)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                    }
                    
                    if !currentValue.isEmpty {
                        Text("\(currentValue)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.black)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    
    func createSlices() -> [PieSlice] {
        var slices = [PieSlice]()
        events.enumerated().forEach { (index, data) in
            let value = normalizedValue(index: index, data: events)
            if slices.isEmpty {
                slices.append((.init(startDegree: 0, endDegree: value * 360)))
            } else {
                slices.append(.init(startDegree: slices.last!.endDegree,
                                    endDegree: (value * 360 + slices.last!.endDegree)))
            }
        }
        return slices
    }
    
    func updateCurrentValue(inPie pieSize: CGRect) {
        guard let angle = angleAtTouchLocation(inPie: pieSize,
                                               touchLocation: touchLocation)
        else {return}
        let currentIndex = createSlices().firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) ?? -1

//        currentLabel = data[currentIndex].label
//        currentValue = "\(data[currentIndex].value)"
    }
    
    func resetValues() {
//        currentValue = ""
//        currentLabel = ""
        touchLocation = .init(x: -1, y: -1)
    }
    
    func sliceIsTouched(slice: PieSlice, inPie pieSize: CGRect) -> Bool {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return false }
        return createSlices().first(where: { $0.startDegree < angle && $0.endDegree > angle }) == slice
    }
}
