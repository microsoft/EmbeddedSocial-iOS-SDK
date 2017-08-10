//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import SlideMenuControllerSwift

public protocol SideMenuItemsProvider: class {
    
    func numberOfItems() -> Int
    func image(forItem index: Int) -> UIImage
    func title(forItem index: Int) -> String
    func destination(forItem index: Int) -> UIViewController
}

protocol NavigationStackProtocol {
    
    func show(_ viewController: UIViewController)
    func push(_ viewController: UIViewController)
    func closeMenu()
    func openMenu()
    func cleanStack()
    func showError(_ error: Error)
    
    var navigationController: UINavigationController { get }
}

public class NavigationStack: NavigationStackProtocol {
    
    private(set) var navigationController: UINavigationController
    private var container: NavigationStackContainer
    private var window: UIWindow
    private var menuStackController: MenuStackController!
    
    func closeMenu() {
        menuStackController.closeSideMenu()
    }
    
    func openMenu() {
        menuStackController.openSideMenu()
    }
    
    func show(_ viewController: UIViewController) {
        container.show(viewController: viewController)
    }
    
    func push(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func cleanStack() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func showError(_ error: Error) {
        navigationController.showErrorAlert(error)
    }
    
    init(window: UIWindow, menuViewController: UIViewController) {
        
        self.window = window
        
        // container for all View Controllers shown through framework
        container = StoryboardScene.MenuStack.instantiateNavigationStackContainer()
        // container is embedded into navigation controller
        navigationController = UINavigationController(rootViewController: self.container)
        
        menuStackController = MenuStackController(mainViewController: navigationController,
                                            leftMenuViewController: menuViewController)
        
        window.rootViewController = menuStackController
    }
}
