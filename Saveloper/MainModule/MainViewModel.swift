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
    
    @Published var events: FetchRequest<Events>
    @Published var categories: FetchRequest<Category>
    private var cancelBag = CancelBag()
    
    init() {
        let request: NSFetchRequest<Events> = Events.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Events.value, ascending: false)
        ]
        events = FetchRequest(fetchRequest: request)
        
        let requestCat: NSFetchRequest<Category> = Category.fetchRequest()
        requestCat.sortDescriptors = [
            NSSortDescriptor(keyPath: \Category.category, ascending: false)
        ]
        categories = FetchRequest(fetchRequest: requestCat)
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
