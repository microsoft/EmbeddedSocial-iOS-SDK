//
//  File.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift

public protocol SideMenuItemsProvider: class {
    
    func numberOfItems() -> Int
    func image(forItem index: Int) -> UIImage
    func title(forItem index: Int) -> String
    func destination(forItem index: Int) -> UIViewController
}

class NavigationStack {
    
    var navigationController: UINavigationController
    var container: NavigationStackContainer
    var window: UIWindow
    var socialMenuItemsProvider = SocialMenuItemsProvider()
    
    init(window: UIWindow,
         format: SideMenuType,
         menuItemsProvider: SideMenuItemsProvider?) {
        
        self.window = window
        
        container = StoryboardScene.MenuStack.instantiateNavigationStackContainer()
        navigationController = UINavigationController(rootViewController: self.container)
        
        window.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        
        
        let menuController = StoryboardScene.MenuStack.instantiateSideMenuViewController()
        
        SideMenuModuleConfigurator.configure(viewController: menuController,
                                             type: format,
                                             socialMenuItemsProvider: socialMenuItemsProvider,
                                             clientMenuItemsProvider: menuItemsProvider)
        
        let presenter = MenuStackController(mainViewController: navigationController,
                                            leftMenuViewController: menuController)
        
        window.rootViewController = presenter;
    }
}
