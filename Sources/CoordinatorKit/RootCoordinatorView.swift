//
//  RootCoordinatorView.swift
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation
import SwiftUI

public struct RootCoordinatorView: View {
  public let coordinator: (UIWindow) -> RootCoordinator

  @State private var rootCoordinator: RootCoordinator?

  public init(coordinator: @escaping (UIWindow) -> RootCoordinator) {
    self.coordinator = coordinator
  }

  public var body: some View {
    EmptyView()
      .withHostingWindow { window in
        guard let window = window, rootCoordinator == nil else { return }
        rootCoordinator = coordinator(window)
        // fixes Unbalanced calls to begin/end appearance transitions
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3)) {
          rootCoordinator?.start()
        }
      }
  }
}

extension View {
  func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
    return background(
      HostingWindowFinder(callback: callback)
    )
  }
}

struct HostingWindowFinder: UIViewRepresentable {
  var callback: (UIWindow?) -> ()

  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async { [weak view] in
      self.callback(view?.window)
    }
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {
  }
}
