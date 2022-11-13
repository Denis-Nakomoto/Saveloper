//
//  PieChart.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 10.11.2022.
//

import SwiftUI

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
    @State private var pieSlices: [PieSlice]
        
    init(pieSlices: [PieSlice]) {
        self.pieSlices = pieSlices
    }
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    ZStack  {
                        ForEach(0..<pieSlices.count) { i in
                            PieChartSlice(center: CGPoint(x: geometry.frame(in: .local).midX, y: geometry.frame(in:  .local).midY), radius: geometry.frame(in: .local).width/2, startDegree: pieSlices[i].startDegree, endDegree: pieSlices[i].endDegree, isTouched: sliceIsTouched(index: i, inPie: geometry.frame(in:  .local)), accentColor: accentColors.randomElement() ?? .white, separatorColor: .white)
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
                VStack  {
                    if !currentLabel.isEmpty   {
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
    
    func updateCurrentValue(inPie pieSize: CGRect) {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation)    else    {return}
        let currentIndex = pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) ?? -1
//
//        currentLabel = data[currentIndex].label
//        currentValue = "\(data[currentIndex].value)"
    }
    
    func resetValues() {
//        currentValue = ""
//        currentLabel = ""
        touchLocation = .init(x: -1, y: -1)
    }
    
    func sliceIsTouched(index: Int, inPie pieSize: CGRect) -> Bool {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return false }
        return pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) == index
    }
}
