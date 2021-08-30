//
//  CoordinatorStorage.swift
//
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation

public final class CoordinatorStorage {
  private(set) var childCoordinators: [AnyObject]

  public init() {
    self.childCoordinators = []
  }


  public func append(_ coordinator: AnyObject) {
    childCoordinators.append(coordinator)
  }

  public func remove(_ coordinator: AnyObject) {
    for (index, childCoordinator) in childCoordinators.enumerated() {
      if coordinator === childCoordinator {
        childCoordinators.remove(at: index)
        break
      }
    }
  }

  public func removeAll() {
    childCoordinators.removeAll()
  }
}
