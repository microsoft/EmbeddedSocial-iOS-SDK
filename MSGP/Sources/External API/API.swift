//
//  API.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift

public protocol MenuItemsDelegate {
    
    func viewController(forItem: Int)
    
}

public class API {
    
    fileprivate static var navigationStack: NavigationStack?
    
    public static var items = [String]()
    
    public static func injectMenuStackIntoApp(window: UIWindow, format: NavigationStackFormat = .single) {
        
        navigationStack = NavigationStack(window: window, format: format)
        
    }
    
    public static func setMenuItems(_ : [String], delegate: MenuItemsDelegate?) {
        
    }
    
}
