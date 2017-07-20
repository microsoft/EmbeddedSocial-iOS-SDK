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

public class NavigationStack {
    
    var navigationController: UINavigationController
    var container: NavigationStackContainer
    var window: UIWindow
    
    init(window: UIWindow, menuViewController: UIViewController) {
        
        self.window = window
        
        // container for all VCs go through menu
        container = StoryboardScene.MenuStack.instantiateNavigationStackContainer()
        // container is embedded into navigation controller
        navigationController = UINavigationController(rootViewController: self.container)
        
        let presenterController = MenuStackController(mainViewController: navigationController,
                                            leftMenuViewController: menuViewController)
        
        window.rootViewController = presenterController
    }
}
