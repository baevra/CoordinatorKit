# CoordinatorKit

An tool to implement navigation via coordinator + router for both UIKit and SwiftUI screens.

## Installation

Add the package via [Swift Package Manager](https://www.swift.org/package-manage/), specify the URL to the repository.

## Usage

### Base protocols

- `RootCoordinator` is responsible for the root screen

- `RootRouter` is capable of setting the root window

- `FlowCoordinator` is responsible for all navigation flows

- `FlowRouter` is capable of pushing, presenting, dismissing, popping view controllers etc.

### Tutorial

1. A coordinator needs a router to do the job
2. `FlowCoordinator` does not necessarily need a freshly created router - you can make use of its parent coordinator's router
3. To process different endings of coordinator's flow you may specify the result type in `completionHandler`, for example `enum FlowFinish`:
```swift
final class MyFlowCoordinator: FlowCoordinator {
    var completionHandler: ((Result<FlowFinish, FlowCoordinatorError>) -> Void)?
    /* some other code */
}

extension MyFlowCoordinator {
    enum FlowFinish {
        /// Simply close the screen
        case quit
        /// Go to the next step
        case goToTheNextStep
    }
}

```
4. To push a new coordinator from an existing one, you can simply pass a parent coordinator's router to a new one, for example:
```swift
final class MenuCoordinator: FlowCoordinator {
    let router: FlowRouter
    /* some other code */
}

extension MenuCoordinator {
    func makeSettings() {
        /// Here we pass the `MenuCoordinator`'s router to `SettingsCoordinator`
        let settingsCoordinator = SettingsCoordinator(router: router)
        start(settingsCoordinator)
    }
}

```
5. To start a new coordinator in a modal view with some complex navigation flow you can do the following in the parent coordinator:

- Create a new `UINavigationController`
- Create a new `FlowRouter`
- Create a new `FlowCoordinator`
- Start your new coordinator
- Present the navigation controller

For example, lets open `MyNewCoordinator` in a modal view from `MyParentCoordinator`:
```swift
final class MyParentCoordinator: FlowCoordinator {
    /* some other code */
    
    func startModalCoordinator() {
        let navigationController = UINavigationController()
        let newRouter = FlowRouter(navigationController: navigationController)
        let newCoordinator = MyNewCoordinator(router: newRouter)
        start(newCoordinator) { [weak self] result in
            /// You can do something with the result here if it affects your navigation flow
            self?.router.dismiss(animated: true)
        }
        router.present(navigationController, animated: true)
    }
}
```
Then you can start your normal navigation flow inside `MyNewCoordinator`:
```swift
final class MyNewCoordinator: FlowCoordinator {
    /* some other code */
    
    func start() {
        let view = SwiftUIView(
            goToNextScreen: { [weak self] in
                /// Continue your navigation flow
                self?.openNextScreen()
            },
            goBack: { [weak self] in
                /// Finish your navigation flow with a `cancel` result
                self?.finish(.cancel)
            }
        )
        let host = UIHostingController(rootView: view)
        router.push(host, animated: true)
    }
}
```
