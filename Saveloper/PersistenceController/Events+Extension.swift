//
//  Events+Extension.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 09.11.2022.
//

import Foundation

extension Events {
    static var example: [Events] {
        let controller = PersistenceController(inMemory: true)
        var tasks: [Events] = []
        for i in 0...8 {
            let event = Events(context: controller.container.viewContext)
            event.date = Date()
            event.inOrOut = Bool.random()
            event.favorite = Bool.random()
            event.value = Double(i * 10)
            tasks.append(event)
        }
        return tasks
    }
}
