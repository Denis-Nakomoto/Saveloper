//
//  CancelBag.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 08.11.2022.
//

import Combine

final class CancelBag {
  
  var subscriptions = Set<AnyCancellable>()
  
  func cancel() {
    subscriptions.removeAll()
  }
}

