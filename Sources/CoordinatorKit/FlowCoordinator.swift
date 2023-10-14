import UIKit

public protocol FlowCoordinator: AnyObject, Identifiable {
    associatedtype Value
    var router: FlowRouter { get }
    var completionHandler: ((Result<Value, FlowCoordinatorError>) -> Void)? { get set }
    func start()
}

private var flowCoordinatorStorageKey: Void?
public extension FlowCoordinator {
    private var storage: CoordinatorStorage {
        get {
            guard let storage: CoordinatorStorage = getAssociatedObject(self, forKey: &flowCoordinatorStorageKey) else {
                let storage = CoordinatorStorage()
                setRetainedAssociatedObject(self, value: storage, forKey: &flowCoordinatorStorageKey)
                return storage
            }
            return storage
        }
        set {
            setRetainedAssociatedObject(self, value: newValue, forKey: &flowCoordinatorStorageKey)
        }
    }
    
    func start<Coordinator: FlowCoordinator>(
        _ coordinator: Coordinator,
        completion: ((Result<Coordinator.Value, FlowCoordinatorError>) -> Void)? = nil
    ) {
        let initialVisibleViewController = router.navigationController.visibleViewController
        
        var visibleViewControllerObservation: NSKeyValueObservation?
        var presentedViewControllerObservation: NSKeyValueObservation?
        
        let cleanup = { [weak self, unowned coordinator] in
            self?.storage.remove(coordinator)
            visibleViewControllerObservation?.invalidate()
            presentedViewControllerObservation?.invalidate()
        }
        
        visibleViewControllerObservation = router.observe(
            \.visibleViewController,
             options: .new
        ) { _, change in
            guard let viewController = change.newValue,
                  initialVisibleViewController === viewController
            else { return }
            
            cleanup()
        }
        
        presentedViewControllerObservation = router.observe(
            \.presentedViewController,
             options: [.old, .new]
        ) { _, change in
            guard let oldViewController = change.oldValue,
                  let newViewController = change.newValue,
                  oldViewController != nil && newViewController == nil
            else { return }
            
            cleanup()
        }
        
        coordinator.completionHandler = { [weak self] result in
            completion?(result)
            
            if self?.storage.childCoordinators.isEmpty == true {
                cleanup()
            }
        }
        storage.append(coordinator)
        coordinator.start()
    }
}

public extension FlowCoordinator {
    func cancel() {
        completionHandler?(.failure(.cancel))
    }
    
    func fail(error: Error) {
        completionHandler?(.failure(.custom(error)))
    }
    
    func finish(_ value: Value) {
        completionHandler?(.success(value))
    }
}

public extension FlowCoordinator where Value == Void {
    func finish() {
        completionHandler?(.success(()))
    }
}

public enum FlowCoordinatorError: Error {
    case cancel
    case custom(Error)
    
    public var customError: Error? {
        guard case let .custom(error) = self else { return nil }
        return error
    }
    
    public var isCanceled: Bool {
        guard case .cancel = self else { return false }
        return true
    }
}
