//
//  RootCoordinatorView.swift
//
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation
import SwiftUI

public struct RootCoordinatorView: View {
  public let coordinator: (AppKitOrUIKitWindow) -> RootCoordinator

  @State private var rootCoordinator: RootCoordinator?

  public init(coordinator: @escaping (AppKitOrUIKitWindow) -> RootCoordinator) {
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

extension SwiftUI.View {
  func withHostingWindow(_ callback: @escaping (AppKitOrUIKitWindow?) -> Void) -> some View {
    return background(
      HostingWindowFinder(callback: callback)
    )
  }
}

struct HostingWindowFinder: AppKitOrUIKitViewRepresentable {
  var callback: (AppKitOrUIKitWindow?) -> ()

  func makeUIView(context: Context) -> AppKitOrUIKitView {
    makeView(content: context)
  }
  
  func makeNSView(context: Context) -> AppKitOrUIKitView {
    makeView(content: context)
  }
  
  private func makeView(content: Context) -> AppKitOrUIKitView {
    let view = AppKitOrUIKitView()
    DispatchQueue.main.async { [weak view] in
      self.callback(view?.window)
    }
    return view
  }

  func updateUIView(_ uiView: AppKitOrUIKitView, context: Context) {}
  
  func updateNSView(_ nsView: AppKitOrUIKitView, context: Context) {}
}
