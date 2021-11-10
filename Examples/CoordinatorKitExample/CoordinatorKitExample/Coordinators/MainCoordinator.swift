//
//  MainCoordinator.swift
//  CoordinatorKitExample
//
//  Created by Roman Baev on 09.11.2021.
//

import Foundation
import UIKit
import CoordinatorKit

final class MainCoordinator: FlowCoordinator {
  let router: FlowRouter
  let storage: CoordinatorStorage

  var onFinish: ((Result<Void, FlowCoordinatorError>) -> Void)?

  init(router: FlowRouter) {
    self.router = router
    self.storage = .init()
    print("MAIN START")
  }

  deinit {
    print("MAIN DEINIT")
  }

  func start() {
    startMain()
  }

  func startMain() {
    let vc = UIViewController()
    vc.view.backgroundColor = .cyan
    vc.navigationItem.title = "Main"
    vc.navigationItem.rightBarButtonItem = .item(.action) { [unowned self] _ in
      startFeatures()
    }
    router.push(vc, animated: true)
  }

  func startFeatures() {
    let navigationController = UINavigationController()
    let router = FlowRouter(navigationController: navigationController)
    let coordinator = FeaturesCoordinator(router: router)

    start(coordinator) { _ in }

    self.router.present(
      navigationController,
      animated: true,
      completion: { print("COMPLETION") },
      onDismiss: {
        print("ON DISMISS")
      }
    )
  }
}
