//
//  MainViewModel.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import Combine
import CoreData
import SwiftUI

class MainViewModel: ObservableObject {

    @Published var tasks: FetchRequest<Events>
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
//    private var usersService: TasksServiceProtocol
    private var cancelBag = CancelBag()
    
    init() {
        let request: NSFetchRequest<Events> = Events.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Events.value, ascending: false)
        ]
        tasks = FetchRequest(fetchRequest: request)
    }
    
//    public func onAppear() {
//        self.getUsers(count: 40)
//    }
    
//    private func getUsers(count: Int) {
//        usersService.getUsers(count: count)
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                switch completion {
//                case .failure(let error):
//                    print(error)
//                case .finished: break
//                }
//            } receiveValue: { [weak self] users in
//                self?.users = users
//            }
//            .store(in: cancelBag)
    //    }
    
//    func createSlices() -> [PieSlice] {
//        var slices = [PieSlice]()
//        tasks.wrappedValue.enumerated().forEach { (index, data) in
//            let value = normalizedValue(index: index, data: tasks)
//            if slices.isEmpty {
//                slices.append((.init(startDegree: 0, endDegree: value * 360)))
//            } else {
//                slices.append(.init(startDegree: slices.last!.endDegree,
//                                    endDegree: (value * 360 + slices.last!.endDegree)))
//            }
//        }
//        return slices
//    }
}

