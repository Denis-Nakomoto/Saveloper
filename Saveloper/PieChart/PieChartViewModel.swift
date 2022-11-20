//
//  PieChartViewModel.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 19.11.2022.
//

import SwiftUI

class PieChartViewModel: ObservableObject {
    
    var selectedEvent: Events?
    
    @Published var currentValue = ""
    @Published var currentLabel = ""
    @Published var touchLocation: CGPoint = .init(x: -1, y: -1)
    @Published var showDetailedEvent = false
    
    func createSlices(events: FetchedResults<Events>) -> [PieSlice] {
        var slices = [PieSlice]()
        events.enumerated().forEach { (index, data) in
            let value = normalizedValue(index: index, data: events)
            if slices.isEmpty {
                slices.append((.init(startDegree: 0, endDegree: value * 360, event: data)))
            } else {
                slices.append(.init(startDegree: slices.last!.endDegree,
                                    endDegree: (value * 360 + slices.last!.endDegree), event: data))
            }
        }
        return slices
    }
    
    func updateCurrentValue(inPie pieSize: CGRect, events: FetchedResults<Events>) {
        guard let angle = angleAtTouchLocation(inPie: pieSize,
                                               touchLocation: touchLocation)
        else { return }
        let currentIndex = createSlices(events: events).firstIndex(where: {
            $0.startDegree < angle && $0.endDegree > angle
        }) ?? -1

//        currentLabel = data[currentIndex].label
//        currentValue = "\(data[currentIndex].value)"
    }
    
    func resetValues() {
//        currentValue = ""
//        currentLabel = ""
        touchLocation = .init(x: -1, y: -1)
    }
    
    func sliceIsTouched(slice: PieSlice, inPie pieSize: CGRect,
                        events: FetchedResults<Events>) -> Bool {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return false }
        return createSlices(events: events).first(where: { $0.startDegree < angle && $0.endDegree > angle }) == slice
    }
    
    func normalizedValue(index: Int, data: FetchedResults<Events>) -> Double {
        var total = 0.0
        data.forEach { data in
            total += data.value
        }
        return data[index].value/total
    }
    
    func angleAtTouchLocation(inPie pieSize: CGRect, touchLocation: CGPoint) -> Double? {
         let difX = touchLocation.x - pieSize.midX
         let difY = touchLocation.y - pieSize.midY
         
         let distanceToCenter = (difX * difX + difY * difY).squareRoot()
         let radius = pieSize.width/2
         guard distanceToCenter <= radius else {
             return nil
         }
         let angleAtTouchLocation = Double(atan2(difY, difX) * (180 / .pi))
         if angleAtTouchLocation < 0 {
             return (180 + angleAtTouchLocation) + 180
         } else {
             return angleAtTouchLocation
         }
     }
    
}
