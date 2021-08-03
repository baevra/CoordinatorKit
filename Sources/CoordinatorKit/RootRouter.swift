//
//  RootRouter.swift
//
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation
import UIKit

public final class RootRouter: NSObject {
  public let window: UIWindow

  public init(window: UIWindow) {
    self.window = window
    super.init()
  }

  public func setRoot(_ presentable: Presentable) {
    let viewController = presentable.viewController
    window.rootViewController = viewController
    window.makeKeyAndVisible()
  }
}
