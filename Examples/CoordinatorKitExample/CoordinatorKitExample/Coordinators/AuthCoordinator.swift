//
//  AuthCoordinator.swift
//  CoordinatorKitExample
//
//  Created by Roman Baev on 09.11.2021.
//

import Foundation
import UIKit
import CoordinatorKit

final class AuthCoordinator: FlowCoordinator {
  let router: FlowRouter
  let storage: CoordinatorStorage

  var onFinish: ((Result<Void, FlowCoordinatorError>) -> Void)?

  init(router: FlowRouter) {
    self.router = router
    self.storage = .init()
    print("AUTH INIT")
  }

  deinit {
    print("AUTH DEINIT")
  }

  func start() {
    startStep1()
  }

  func startStep1() {
    let vc = UIViewController()
    vc.view.backgroundColor = .systemOrange
    vc.navigationItem.title = "Auth step 1"
    vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
      startStep2()
    }

    router.push(
      vc,
      animated: true,
      completion: {
//        print("COMPLETION")
      },
      onPop: {
//        print("POP")
      }
    )
  }

  func startStep2() {
    let vc = UIViewController()
    vc.view.backgroundColor = .systemMint
    vc.navigationItem.title = "Auth step 2"
    vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
      finish()
    }

    router.push(
      vc,
      animated: true,
      completion: {
//        print("COMPLETION 2")
      },
      onPop: {
//        print("POP 2")
      }
    )
  }
}
