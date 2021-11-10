//
//  OnboardingCoordinator.swift
//  CoordinatorKitExample
//
//  Created by Roman Baev on 09.11.2021.
//

import Foundation
import UIKit
import CoordinatorKit

final class OnboardingCoordinator: FlowCoordinator {
  let router: FlowRouter
  let storage: CoordinatorStorage

  var onFinish: ((Result<Void, FlowCoordinatorError>) -> Void)?

  init(router: FlowRouter) {
    self.router = router
    self.storage = .init()
    print("Onboarding INIT")
  }

  deinit {
    print("Onboarding DEINIT")
  }

  func start() {
    startGreen()
  }

  func startGreen() {
    let vc = UIViewController()
    vc.view.backgroundColor = .systemGreen
    vc.navigationItem.title = "Green"
    vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
      startMint()
    }
    router.push(vc, animated: true)
  }

  func startMint() {
    let vc = UIViewController()
    vc.view.backgroundColor = .systemMint
    vc.navigationItem.title = "Mint"
    vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
      startAuth()
    }
    router.push(vc, animated: true)
  }

  func startAuth() {
    let coordinator = AuthCoordinator(router: router)
    start(coordinator) { [unowned self] result in
      guard case .success = result else { return }
      startWhite()
    }
  }

  func startWhite() {
    let vc = UIViewController()
    vc.view.backgroundColor = .white
    vc.navigationItem.title = "White"
    vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
      finish()
//      startAuth()
    }
    router.push(vc, animated: true)
  }
}
