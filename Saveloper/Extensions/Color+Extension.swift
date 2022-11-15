//
//  Color+Extension.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 11.11.2022.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let aValue, rValue, gValue, bValue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (aValue, rValue, gValue, bValue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (aValue, rValue, gValue, bValue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (aValue, rValue, gValue, bValue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (aValue, rValue, gValue, bValue) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(rValue) / 255,
            green: Double(gValue) / 255,
            blue: Double(bValue) / 255,
            opacity: Double(aValue) / 255
        )
    }
}

extension Color {
    static var fadeBlackColor: Color {
        .black.opacity(0.2)
    }

    static var backgroundColor: Color {
        Color(red: 101/255, green: 120/255, blue: 225/255)
    }
}
