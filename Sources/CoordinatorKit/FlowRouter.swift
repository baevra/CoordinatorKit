import UIKit

public final class FlowRouter: NSObject {
  public let navigationController: UINavigationController

  private(set) var pushCompletions: [UIViewController: () -> Void]
  private(set) var pushPops: [UIViewController: () -> Void]

  private(set) var presentDismisses: [UIPresentationController: () -> Void]

  @objc dynamic weak var visibleViewController: UIViewController?
  @objc dynamic weak var presentedViewController: UIViewController?

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.pushCompletions = [:]
    self.pushPops = [:]
    self.presentDismisses = [:]
    super.init()
    assert(navigationController.delegate == nil, "Navigation delegate conflict")
    self.navigationController.delegate = self
  }

  public func present(
    _ presentable: Presentable,
    animated: Bool,
    completion: (() -> Void)? = nil,
    onDismiss: (() -> Void)? = nil
  ) {
    let viewController = presentable.viewController

    if let onDismiss = onDismiss,
       let presentationController = viewController.presentationController {
      presentDismisses[presentationController] = onDismiss
      presentationController.delegate = self
    }

    presentedViewController = viewController

    navigationController.present(
      viewController,
      animated: animated,
      completion: completion
    )
  }

  public func dismiss(
    animated: Bool,
    completion: (() -> Void)? = nil
  ) {
    navigationController.dismiss(
      animated: animated,
      completion: completion
    )
  }

  public func push(
    _ presentable: Presentable,
    animated: Bool,
    completion: (() -> Void)? = nil,
    onPop: (() -> Void)? = nil
  ) {
    let viewController = presentable.viewController

    if let completion = completion {
      pushCompletions[viewController] = completion
    }

    if let onPop = onPop {
      pushPops[viewController] = onPop
    }

    navigationController.pushViewController(
      viewController,
      animated: animated
    )
  }

  public func pop(animated: Bool)  {
    let popedViewController = navigationController
      .popViewController(animated: animated)
    guard let viewController = popedViewController else { return }
    runPops(for: viewController)
  }

  public func popToPresentable(_ presentable: Presentable, animated: Bool) {
    let viewController = presentable.viewController
    let popedViewControllers = navigationController
      .popToViewController(viewController, animated: animated)
    guard let viewControllers = popedViewControllers else { return }
    viewControllers.forEach(runPops(for:))
  }

  public func popToRoot(animated: Bool) {
    let popedViewControllers = navigationController
      .popToRootViewController(animated: animated)
    guard let viewControllers = popedViewControllers else { return }
    viewControllers.forEach(runPops(for:))
  }

  public func setRoot(
    _ presentable: Presentable,
    animated: Bool
  ) {
    navigationController.setViewControllers(
      [presentable.viewController],
      animated: animated
    )
    pushPops.forEach { $0.value() }
  }

  private func runDismiss(for controller: UIPresentationController) {
    guard let onDismiss = presentDismisses[controller] else { return }
    onDismiss()
    presentDismisses.removeValue(forKey: controller)
  }

  private func runCompletion(for controller: UIViewController) {
    guard let complition = pushCompletions[controller] else { return }
    complition()
    pushCompletions.removeValue(forKey: controller)
  }

  private func runPops(for controller: UIViewController) {
    guard let onPop = pushPops[controller] else { return }
    onPop()
    pushPops.removeValue(forKey: controller)
  }
}

extension FlowRouter: UINavigationControllerDelegate {
  public func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    visibleViewController = viewController

    runCompletion(for: viewController)

    guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
      !navigationController.viewControllers.contains(poppedViewController) else {
      return
    }
    runPops(for: poppedViewController)
  }
}

extension FlowRouter: UIAdaptivePresentationControllerDelegate {
  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    runDismiss(for: presentationController)

    guard presentedViewController === presentationController.presentedViewController else { return }
    presentedViewController = nil
  }
}
