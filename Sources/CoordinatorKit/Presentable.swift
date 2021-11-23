//
//  Presentable.swift
//
//
//  Created by Roman Baev on 30.07.2021.
//

import Foundation

public protocol Presentable {
  var viewController: AppKitOrUIKitViewController { get }
}
