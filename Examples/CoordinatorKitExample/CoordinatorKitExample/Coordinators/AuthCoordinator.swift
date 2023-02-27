import UIKit
import CoordinatorKit

final class AuthCoordinator: FlowCoordinator {
    let router: FlowRouter
    var completionHandler: ((Result<Void, FlowCoordinatorError>) -> Void)?
    
    init(router: FlowRouter) {
        self.router = router
    }
    
    func start() {
        startStep1()
    }
    
    func startStep1() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemOrange
        vc.navigationItem.title = "Auth step 1"
        vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
            startStep2()
        }
        router.push(vc, animated: true, completion: {}, onPop: {})
    }
    
    func startStep2() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemMint
        vc.navigationItem.title = "Auth step 2"
        vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
            finish()
        }
        router.push(vc, animated: true, completion: {}, onPop: {})
    }
}
