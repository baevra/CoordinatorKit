//
//  FlowRouter.swift
//
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation
import UIKit

public final class FlowRouter: NSObject {
  public let navigationController: UINavigationController
  private(set) var pushCompletions: [UIViewController: () -> Void]

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.pushCompletions = [:]
    super.init()
    self.navigationController.delegate = self
  }

  public func present(
    _ presentable: Presentable,
    animated: Bool,
    completion: (() -> Void)? = nil
  ) {
    navigationController.present(
      presentable.viewController,
      animated: animated,
      completion: completion
    )
  }

  public func dismiss(
    animated: Bool,
    completion: (() -> Void)? = nil
  ) {
    navigationController.dismiss(
      animated: animated,
      completion: completion
    )
  }

  public func push(
    _ presentable: Presentable,
    animated: Bool,
    completion: (() -> Void)? = nil
  ) {
    let viewController = presentable.viewController

    if let completion = completion {
      pushCompletions[viewController] = completion
    }

    navigationController.pushViewController(
      viewController,
      animated: animated
    )
  }

  public func pop(animated: Bool)  {
    let popedViewController = navigationController
      .popViewController(animated: animated)
    guard let viewController = popedViewController else { return }
    runCompletion(for: viewController)
  }

  public func popToRoot(animated: Bool) {
    let popedViewControllers = navigationController
      .popToRootViewController(animated: animated)
    guard let viewControllers = popedViewControllers else { return }
    viewControllers.forEach(runCompletion(for:))
  }

  public func setRoot(
    _ presentable: Presentable,
    animated: Bool
  ) {
    navigationController.setViewControllers(
      [presentable.viewController],
      animated: animated
    )
    pushCompletions.forEach { $0.value() }
  }

  private func runCompletion(for controller: UIViewController) {
    guard let completion = pushCompletions[controller] else { return }
    completion()
    pushCompletions.removeValue(forKey: controller)
  }
}

extension FlowRouter: UINavigationControllerDelegate {
  public func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
      !navigationController.viewControllers.contains(poppedViewController) else {
      return
    }
    runCompletion(for: poppedViewController)
  }
}
