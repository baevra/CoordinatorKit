//
//  RootCoordinator.swift
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation

public protocol RootCoordinator: AnyObject {
  var router: RootRouter { get }
  func start()
}

private var rootCoordinatorStorageKey: Void?
public extension RootCoordinator {
  private var storage: CoordinatorStorage {
    get {
      guard let storage: CoordinatorStorage = getAssociatedObject(self, forKey: &rootCoordinatorStorageKey) else {
        let storage = CoordinatorStorage()
        setRetainedAssociatedObject(self, value: storage, forKey: &rootCoordinatorStorageKey)
        return storage
      }
      return storage
    }
    set {
      setRetainedAssociatedObject(self, value: newValue, forKey: &rootCoordinatorStorageKey)
    }
  }

  func start<Coordinator: FlowCoordinator>(
    _ coordinator: Coordinator,
    completion: ((Result<Coordinator.Value, Error>) -> Void)? = nil
  ) {
    coordinator.completionHandler = { [unowned self, unowned coordinator] result in
      storage.remove(coordinator)
      switch result {
      case let .success(value):
        completion?(.success(value))
      case let .failure(error):
        guard case let .custom(error) = error else { return }
        completion?(.failure(error))
      }
    }
    storage.removeAll()
    storage.append(coordinator)
    coordinator.start()
  }
}
