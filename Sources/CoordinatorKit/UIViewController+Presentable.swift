//
//  UIViewController+Presentable.swift
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

extension AppKitOrUIKitViewController: Presentable {
  public var viewController: AppKitOrUIKitViewController {
    return self
  }
}
