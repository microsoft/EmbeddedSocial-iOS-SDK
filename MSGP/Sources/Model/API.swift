//
//  API.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift

public class API {
    
    fileprivate static var navigationStack: NavigationStack?
    
    public static var items = [String]()
    
    public static func injectMenuStackIntoApp(window: UIWindow,
                                              format: SideMenuType,
                                              delegate: SideMenuItemsProvider?) {
        
        navigationStack = NavigationStack(window: window, format: format, menuItemsProvider: delegate)
        
    }
}
