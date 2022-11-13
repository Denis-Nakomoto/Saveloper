//
//  MainConfigurator.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import Foundation

final class MainConfigurator {
    
    public static func configureMainView(
        with viewModel: MainViewModel = MainViewModel()
    ) -> MainView {
        
        let mainView = MainView()
        return mainView
    }
}
