import UIKit

extension UIBarButtonItem {
    static func next(handler: @escaping UIActionHandler) -> UIBarButtonItem {
        .init(systemItem: .fastForward, primaryAction: .init(handler: handler), menu: nil)
    }
    
    static func item(_ systemItem: SystemItem, handler: @escaping UIActionHandler) -> UIBarButtonItem {
        .init(systemItem: systemItem, primaryAction: .init(handler: handler), menu: nil)
    }
}
