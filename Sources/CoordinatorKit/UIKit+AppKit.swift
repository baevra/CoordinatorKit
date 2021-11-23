//
//  UIKit+AppKit.swift
//  
//
//  Created by Alex Ivashko on 23.11.2021.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
public typealias AppKitOrUIKitWindow = UIWindow
public typealias AppKitOrUIKitViewController = UIViewController
public typealias AppKitOrUIKitNavigationController = UINavigationController
public typealias AppKitOrUIKitView = UIView
public typealias AppKitOrUIKitHostingController = UIHostingController
public typealias AppKitOrUIKitViewRepresentable = UIViewRepresentable
public typealias AppKitOrUIKitViewControllerRepresentable = UIViewControllerRepresentable

#elseif canImport(AppKit)
import AppKit
public typealias AppKitOrUIKitWindow = NSWindow
public typealias AppKitOrUIKitViewController = NSViewController
public typealias AppKitOrUIKitNavigationController = NSViewController
public typealias AppKitOrUIKitView = NSView
public typealias AppKitOrUIKitHostingController = NSHostingController
public typealias AppKitOrUIKitViewRepresentable = NSViewRepresentable
public typealias AppKitOrUIKitViewControllerRepresentable = NSViewControllerRepresentable
#endif

