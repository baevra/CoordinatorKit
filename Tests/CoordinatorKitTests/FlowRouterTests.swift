import XCTest
@testable import CoordinatorKit

final class FlowRouterTests: XCTestCase {
  var navigationController: UINavigationController!
  var router: FlowRouter!

  override func setUp() {
    navigationController = UINavigationController()
    router = FlowRouter(navigationController: navigationController)
  }

  func testCorrectSetup() {
    XCTAssertEqual(router.navigationController, navigationController)
    XCTAssertTrue(router.navigationController.viewControllers.isEmpty)
    XCTAssertTrue(router.completions.isEmpty)
  }
}
