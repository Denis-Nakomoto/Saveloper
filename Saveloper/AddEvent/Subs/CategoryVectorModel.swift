//
//  CategoryVectorModel.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 20.11.2022.
//

import Foundation
import CoreData

struct CategoryVector: Hashable {
    var xCoordinate: CGFloat = 0
    var yCoordinate: CGFloat = 0
    var category = ""
    var objectId: NSManagedObjectID = NSManagedObjectID()
}
