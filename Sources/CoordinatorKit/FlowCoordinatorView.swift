//
//  FlowCoordinatorView.swift
//
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation
import SwiftUI

public struct FlowCoordinatorView<Coordinator: FlowCoordinator>: View {
  public let coordinator: Coordinator

  public init(coordinator: Coordinator) {
    self.coordinator = coordinator
  }

  public var body: some View {
    _CoordinatorView(navigationController: coordinator.router.navigationController)
      .edgesIgnoringSafeArea(.all)
      .onAppear(perform: coordinator.start)
  }
}

private struct _CoordinatorView: UIViewControllerRepresentable {
  let navigationController: UINavigationController

  func makeUIViewController(context: Context) -> UIViewController {
    return navigationController
  }

  func updateUIViewController(
    _ viewController: UIViewController,
    context: Context
  ) {}
}
