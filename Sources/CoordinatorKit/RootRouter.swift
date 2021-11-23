//
//  RootRouter.swift
//
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public final class RootRouter: NSObject {
  public let window: AppKitOrUIKitWindow

  public init(window: AppKitOrUIKitWindow) {
    self.window = window
    super.init()
  }

  public func setRoot(_ presentable: Presentable) {
    let viewController = presentable.viewController
    #if canImport(UIKit)
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    #elseif canImport(AppKit)
    window.contentViewController = viewController
    window.makeKeyAndOrderFront(nil)
    #endif
  }
}
