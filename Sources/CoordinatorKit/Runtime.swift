//
//  Runtime.swift
//
//  Created by Roman Baev on 17.01.2023.
//

import Foundation

func getAssociatedObject<T>(_ object: Any, forKey key: UnsafeRawPointer) -> T? {
  return objc_getAssociatedObject(object, key) as? T
}

func setRetainedAssociatedObject<T>(_ object: Any, value: T, forKey key: UnsafeRawPointer) {
  objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

func setAssignAssociatedObject<T>(_ object: Any, value: T, forKey key: UnsafeRawPointer) {
  objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_ASSIGN)
}
