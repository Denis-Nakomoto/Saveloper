//
//  Optional+Extension.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 13.11.2022.
//

import Foundation

extension Optional where Wrapped == String {
    var orEmpty: String {
        switch self {
        case .some(let value):
            return value
        case .none:
            return ""
        }
    }
}
