//
//  PieHelper.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 10.11.2022.
//

import SwiftUI

func normalizedValue(index: Int, data: FetchedResults<Events>) -> Double {
    var total = 0.0
    data.forEach { data in
        total += data.value
    }
    return data[index].value/total
}

struct PieSlice: Hashable {
     var startDegree: Double
     var endDegree: Double
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
