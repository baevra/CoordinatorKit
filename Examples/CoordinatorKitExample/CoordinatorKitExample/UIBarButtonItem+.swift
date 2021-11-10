//
//  UIBarButtonItem+.swift
//  CoordinatorKitExample
//
//  Created by Roman Baev on 09.11.2021.
//

import Foundation
import UIKit

extension UIBarButtonItem {
  static func next(handler: @escaping UIActionHandler) -> UIBarButtonItem {
    return .init(systemItem: .fastForward, primaryAction: .init(handler: handler), menu: nil)
  }

  static func item(_ systemItem: SystemItem, handler: @escaping UIActionHandler) -> UIBarButtonItem {
    return .init(systemItem: systemItem, primaryAction: .init(handler: handler), menu: nil)
  }
}
