import Foundation
import UIKit

public final class RootRouter: NSObject {
    public let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    public func setRoot(_ presentable: Presentable) {
        let viewController = presentable.viewController
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
