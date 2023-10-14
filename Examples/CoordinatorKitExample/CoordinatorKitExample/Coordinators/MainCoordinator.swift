import UIKit
import CoordinatorKit

final class MainCoordinator: FlowCoordinator {
    let router: FlowRouter
    var completionHandler: ((Result<Void, FlowCoordinatorError>) -> Void)?
    
    init(router: FlowRouter) {
        self.router = router
    }
    
    func start() {
        startMain()
    }
    
    func startMain() {
        let vc = UIViewController()
        vc.view.backgroundColor = .cyan
        vc.navigationItem.title = "Main"
        vc.navigationItem.rightBarButtonItem = .item(.action) { [unowned self] _ in
            startFeatures()
        }
        router.push(vc, animated: true)
    }
    
    func startFeatures() {
        let navigationController = UINavigationController()
        let router = FlowRouter(navigationController: navigationController)
        let coordinator = FeaturesCoordinator(router: router)
        start(coordinator)
        self.router.present(navigationController, animated: true, completion: {}, onDismiss: {})
    }
}
