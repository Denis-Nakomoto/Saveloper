//
//  CircluarMenuButtonItem.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 20.11.2022.
//

import SwiftUI

struct CircluarMenuButtonItem: View {
    @State var imageName: String
    var handler: (String) -> Void
    var body: some View {
        Button {
            handler(imageName)
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
        }
    }
}
