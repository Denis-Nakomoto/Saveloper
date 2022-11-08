//
//  MainView.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import SwiftUI

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.users.data) { user in
                
                NavigationLink(
                    destination: MainRouter.destinationForTappedUser(
                        user: user)
                ) {
                    Text(user.firstName)
                }
                
            }.navigationTitle("Users")
        }.onAppear(perform: {
            viewModel.onAppear()
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}

