//
//  FlowCoordinator.swift
//
//
//  Created by Roman Baev on 30.06.2021.
//

import Foundation
#if canImport(UIKit)
import UIKit

//public final class FlowCoordinator<Value>: NSObject, Identifiable {
//  public typealias Value = Value
//  public let router: FlowRouter
//  public let storage: CoordinatorStorage
//
//  public var onFinish: ((Result<Value, FlowCoordinatorError>) -> Void)?
//
//  public init(router: FlowRouter) {
//    self.router = router
//    self.storage = .init()
//  }
//
//  public func start() {}
//}

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
    let initialVisibleViewController = router.navigationController.visibleViewController

    var visibleViewControllerObservation: NSKeyValueObservation?
    var presentedViewControllerObservation: NSKeyValueObservation?

    let completion = { [weak self, unowned coordinator] in
      self?.storage.remove(coordinator)
      visibleViewControllerObservation?.invalidate()
      presentedViewControllerObservation?.invalidate()
    }

    visibleViewControllerObservation = router.observe(
      \.visibleViewController,
       options: .new
    ) { _, change in
      guard let viewController = change.newValue,
            initialVisibleViewController === viewController
      else { return }

      completion()
    }

    presentedViewControllerObservation = router.observe(
      \.presentedViewController,
       options: [.old, .new]
    ) { _, change in
      guard let oldViewController = change.oldValue,
            let newViewController = change.newValue,
            oldViewController != nil && newViewController == nil
      else { return }

      completion()
    }

    coordinator.onFinish = { [weak self] result in
      switch result {
      case let .success(value):
        onFinish(.success(value))
      case let .failure(error):
        switch error {
        case .cancel:
          onCancel()
        case let .custom(error):
          onFinish(.failure(error))
        }
      }

      if self?.storage.childCoordinators.isEmpty == true {
        completion()
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
#endif

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
