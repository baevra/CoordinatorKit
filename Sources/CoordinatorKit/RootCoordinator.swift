//
//  RootCoordinator.swift
//
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation
public protocol RootCoordinator: AnyObject {
  var router: RootRouter { get }
  var storage: CoordinatorStorage { get }
  func start()
}

#if canImport(UIKit)

public extension RootCoordinator {
  func start<Coordinator: FlowCoordinator>(
    _ coordinator: Coordinator,
    onFinish: @escaping (Result<Coordinator.Value, Error>) -> Void
  ) {
    coordinator.onFinish = { [unowned self, unowned coordinator] result in
      storage.remove(coordinator)
      switch result {
      case let .success(value):
        onFinish(.success(value))
      case let .failure(error):
        guard case let .custom(error) = error else { return }
        onFinish(.failure(error))
      }
    }
    storage.removeAll()
    storage.append(coordinator)
    coordinator.start()
  }
}
#endif
