//
//  PieHelper.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 10.11.2022.
//

import SwiftUI

func normalizedValue(index: Int, data: FetchRequest<Events>) -> Double {
    var total = 0.0
    data.wrappedValue.forEach { data in
        total += data.value
    }
    return data.wrappedValue[index].value/total
}

struct PieSlice {
     var startDegree: Double
     var endDegree: Double
 }

func angleAtTouchLocation(inPie pieSize: CGRect, touchLocation: CGPoint) ->  Double? {
     let dx = touchLocation.x - pieSize.midX
     let dy = touchLocation.y - pieSize.midY
     
     let distanceToCenter = (dx * dx + dy * dy).squareRoot()
     let radius = pieSize.width/2
     guard distanceToCenter <= radius else {
         return nil
     }
     let angleAtTouchLocation = Double(atan2(dy, dx) * (180 / .pi))
     if angleAtTouchLocation < 0 {
         return (180 + angleAtTouchLocation) + 180
     } else {
         return angleAtTouchLocation
     }
 }
