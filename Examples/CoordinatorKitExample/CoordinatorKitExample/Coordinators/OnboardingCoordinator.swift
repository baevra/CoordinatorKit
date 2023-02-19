import UIKit
import CoordinatorKit

final class OnboardingCoordinator: FlowCoordinator {
    let router: FlowRouter
    let storage: CoordinatorStorage
    
    var completionHandler: ((Result<Void, FlowCoordinatorError>) -> Void)?
    
    init(router: FlowRouter) {
        self.router = router
        self.storage = .init()
        print("Onboarding INIT")
    }
    
    deinit {
        print("Onboarding DEINIT")
    }
    
    func start() {
        startStep1()
    }
    
    func startStep1() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemRed
        vc.navigationItem.title = "Onboarding step 1"
        vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
            startStep2()
        }
        router.push(vc, animated: true)
    }
    
    func startStep2() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemYellow
        vc.navigationItem.title = "Onboarding step 2"
        vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
            startStep3()
        }
        router.push(vc, animated: true)
    }
    
    func startStep3() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGreen
        vc.navigationItem.title = "Onboarding step 3"
        vc.navigationItem.rightBarButtonItem = .next { [unowned self] _ in
            startAuth()
        }
        router.push(vc, animated: true)
    }
    
    func startAuth() {
        let coordinator = AuthCoordinator(router: router)
        start(coordinator) { [unowned self] result in
            guard case .success = result else { return }
            finish()
        }
    }
    
}
