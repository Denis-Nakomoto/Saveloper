//
//  MainViewModel.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
    @Published public var tasks = Tasks(data: [])
    
//    private var usersService: TasksServiceProtocol
    private var cancelBag = CancelBag()
    
    init(users: Tasks = Tasks(data: [])) {
        self.users = users
//        self.usersService = usersService
    }
    
    public func onAppear() {
        self.getUsers(count: 40)
    }
    
    private func getUsers(count: Int) {
        usersService.getUsers(count: count)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
            } receiveValue: { [weak self] users in
                self?.users = users
            }
            .store(in: cancelBag)
    }
}

