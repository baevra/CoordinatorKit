import XCTest
@testable import CoordinatorKit

#if canImport(UIKit)
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
    let coordinator = NumbersCoordinator(router: router)
    storage.append(coordinator)
    XCTAssertEqual(storage.childCoordinators.count, 1)
    XCTAssertTrue(storage.childCoordinators.first is NumbersCoordinator)
    storage.remove(coordinator)
    XCTAssertTrue(storage.childCoordinators.isEmpty)
  }
}

fileprivate final class NumbersCoordinator: FlowCoordinator {
  let router: FlowRouter
  let storage: CoordinatorStorage

  init(router: FlowRouter) {
    self.router = router
    self.storage = .init()
  }

  func start() {
  }
  
  var onFinish: ((Result<Void, FlowCoordinatorError>) -> Void)? = nil
}
#endif
