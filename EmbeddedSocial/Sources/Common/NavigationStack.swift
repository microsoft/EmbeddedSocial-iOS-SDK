//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import SlideMenuControllerSwift

public protocol SideMenuItemsProvider: class {
    
    func numberOfItems() -> Int
    func image(forItem index: Int) -> UIImage
    func imageHighlighted(forItem index: Int) -> UIImage
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
    func dismissModal()
    func presentModal(_ viewControllerToPresent: UIViewController, parentViewController: UIViewController?)
    
    var navigationController: UINavigationController { get }
}

public class NavigationStack: NavigationStackProtocol {
    
    private(set) var navigationController: UINavigationController
    private var menuStackController: MenuStackController!
    private var presentedModal: UIViewController?
    
    func closeMenu() {
        menuStackController.closeSideMenu()
    }
    
    func openMenu() {
        menuStackController.openSideMenu()
    }
    
    func show(_ viewController: UIViewController) {
    
        viewController.addLeftBarButtonWithImage(Asset.iconHamburger.image)
        viewController.slideMenuController()?.removeLeftGestures()
        viewController.slideMenuController()?.addLeftGestures()
        
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func push(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func cleanStack() {
        navigationController.dismiss(animated: true, completion: nil)
        navigationController.popToRootViewController(animated: true)
    }
    
    func dismissModal() {
        presentedModal?.dismiss(animated: true)
    }
    
    func presentModal(_ viewControllerToPresent: UIViewController, parentViewController: UIViewController?) {
        let parent = parentViewController ?? navigationController
        parent.present(viewControllerToPresent, animated: true)
        presentedModal = viewControllerToPresent
    }
    
    func showError(_ error: Error) {
        navigationController.showErrorAlert(error)
    }
    
    init(window: UIWindow, menuViewController: UIViewController) {
 
        navigationController = BaseNavigationController()
        
        menuStackController = MenuStackController(mainViewController: navigationController,
                                            leftMenuViewController: menuViewController)
        
        window.rootViewController = menuStackController
    }
}
