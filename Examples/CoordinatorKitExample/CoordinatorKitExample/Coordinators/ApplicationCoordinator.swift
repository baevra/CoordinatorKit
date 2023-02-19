import UIKit
import CoordinatorKit

final class ApplicationCoordinator: RootCoordinator {
    let router: RootRouter
    let storage: CoordinatorStorage
    
    init(router: RootRouter) {
        self.router = router
        self.storage = .init()
    }
    
    func start() {
        startOnboarding()
    }
    
    func startOnboarding() {
        let navigationController = UINavigationController()
        let router = FlowRouter(navigationController: navigationController)
        let coordinator = OnboardingCoordinator(router: router)
        self.start(coordinator) { [unowned self] _ in
            startMain()
        }
        self.router.setRoot(navigationController)
    }
    
    func startMain() {
        let navigationController = UINavigationController()
        let router = FlowRouter(navigationController: navigationController)
        let coordinator = MainCoordinator(router: router)
        self.start(coordinator) { _ in }
        self.router.setRoot(navigationController)
    }
}
