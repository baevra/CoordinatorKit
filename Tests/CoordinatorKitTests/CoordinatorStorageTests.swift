import XCTest
@testable import CoordinatorKit

final class CoordinatorStorageTests: XCTestCase {
    var storage: CoordinatorStorage!

    override func setUp() {
        storage = CoordinatorStorage()
    }

    func testEmptyStorage() {
        XCTAssertTrue(storage.childCoordinators.isEmpty)
    }

    func testStorage() {
        let navigationController = UINavigationController()
        let router = FlowRouter(navigationController: navigationController)
        let coordinator = TestCoordinator(router: router)
        storage.append(coordinator)
        XCTAssertEqual(storage.childCoordinators.count, 1)
        XCTAssertTrue(storage.childCoordinators.first is TestCoordinator)
        storage.remove(coordinator)
        XCTAssertTrue(storage.childCoordinators.isEmpty)
    }
}

extension CoordinatorStorageTests {
    final class TestCoordinator: FlowCoordinator {
        var completionHandler: ((Result<Void, FlowCoordinatorError>) -> Void)?
        var router: FlowRouter

        init(router: FlowRouter) {
            self.router = router
        }

        func start() {}
    }
}
