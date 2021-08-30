//
//  FlowCoordinator.swift
//
//
//  Created by Roman Baev on 30.06.2021.
//

import Foundation
import UIKit

public protocol FlowCoordinator: AnyObject, Identifiable {
  associatedtype Value
  var router: FlowRouter { get }
  var storage: CoordinatorStorage { get }
  var onFinish: ((Result<Value, FlowCoordinatorError>) -> Void)? { get set }
  func start()
}

public extension FlowCoordinator {
  func start<Coordinator: FlowCoordinator>(
    _ coordinator: Coordinator,
    onFinish: @escaping (Result<Coordinator.Value, Error>) -> Void
  ) {
    start(coordinator, onCancel: {}, onFinish: onFinish)
  }

  func start<Coordinator: FlowCoordinator>(
    _ coordinator: Coordinator,
    onCancel: @escaping () -> Void,
    onFinish: @escaping (Result<Coordinator.Value, Error>) -> Void
  ) {
    let completion = { [unowned self, unowned coordinator] in
      storage.remove(coordinator)
    }
    coordinator.onFinish = { result in
      switch result {
      case let .success(value):
        onFinish(.success(value))
      case let .failure(error):
        switch error {
        case .cancel:
          completion()
          onCancel()
        case let .custom(error):
          onFinish(.failure(error))
        }
      }
    }
    storage.append(coordinator)
    coordinator.start()
  }
}

public extension FlowCoordinator {
  func cancel() {
    onFinish?(.failure(.cancel))
  }

  func fail(error: Error) {
    onFinish?(.failure(.custom(error)))
  }

  func finish(_ value: Value) {
    onFinish?(.success(value))
  }
}

public extension FlowCoordinator where Value == Void {
  func finish() {
    onFinish?(.success(()))
  }
}

public enum FlowCoordinatorError: Error {
  case cancel
  case custom(Error)

  public var customError: Error? {
    guard case let .custom(error) = self else { return nil }
    return error
  }

  public var isCanceled: Bool {
    guard case .cancel = self else { return false }
    return true
  }
}
