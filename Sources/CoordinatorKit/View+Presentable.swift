//
//  View+Presentable.swift
//
//
//  Created by Roman Baev on 03.08.2021.
//

import Foundation
import SwiftUI

extension View {
  func wrapToPresentable(title: String) -> Presentable {
    let viewController = AppKitOrUIKitHostingController(rootView: self)
    viewController.title = title
    return viewController
  }
}
