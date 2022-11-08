//
//  MainRouter.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import SwiftUI

final class MainRouter {
    
    public static func destinationForTappedUser(user: Tassk) -> some View {
        return MainConfigurator.configureMainView(with: user)
    }
}
