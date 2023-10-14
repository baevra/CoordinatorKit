import Foundation

func getAssociatedObject<T>(_ object: Any, forKey key: UnsafeRawPointer) -> T? {
    objc_getAssociatedObject(object, key) as? T
}

func setRetainedAssociatedObject<T>(_ object: Any, value: T, forKey key: UnsafeRawPointer) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

func setAssignAssociatedObject<T>(_ object: Any, value: T, forKey key: UnsafeRawPointer) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_ASSIGN)
}
