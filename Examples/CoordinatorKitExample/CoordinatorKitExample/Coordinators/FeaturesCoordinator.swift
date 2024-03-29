//
//  FeaturesCoordinator.swift
//  CoordinatorKitExample
//
//  Created by Roman Baev on 09.11.2021.
//

import Foundation
import UIKit
import CoordinatorKit

final class FeaturesCoordinator: FlowCoordinator {
  let router: FlowRouter

  var completionHandler: ((Result<Void, FlowCoordinatorError>) -> Void)?

  init(router: FlowRouter) {
    self.router = router
    print("FEATURES INIT")
  }

  deinit {
    print("FEATURES DEINIT")
  }

  func start() {
    startFeature1()
  }

  func startFeature1() {
    let vc = UIViewController()
    vc.view.backgroundColor = .systemCyan
    vc.navigationItem.title = "Feature 2"
    vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
      startFeature2()
    }
    router.push(vc, animated: false)
  }

  func startFeature2() {
    let vc = UIViewController()
    vc.view.backgroundColor = .systemBlue
    vc.navigationItem.title = "Feature 2"
    vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
      finish()
    }
    router.push(vc, animated: true)
  }
}
