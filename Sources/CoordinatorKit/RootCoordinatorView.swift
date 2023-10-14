import Foundation
import SwiftUI

public struct RootCoordinatorView: View {
    @State private var rootCoordinator: RootCoordinator?
    
    public let coordinator: (UIWindow) -> RootCoordinator
    
    public init(coordinator: @escaping (UIWindow) -> RootCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        EmptyView()
            .withHostingWindow { window in
                guard let window = window, rootCoordinator == nil else { return }
                rootCoordinator = coordinator(window)
                // fixes Unbalanced calls to begin/end appearance transitions
                Task { @MainActor in
                    try await Task.sleep(nanoseconds: 3000000)
                    rootCoordinator?.start()
                }
            }
    }
}

extension View {
    func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        background(HostingWindowFinder(callback: callback))
    }
}

struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        Task { @MainActor [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
