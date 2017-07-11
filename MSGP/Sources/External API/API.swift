//
//  API.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

public protocol MenuItemsDelegate {
    
    func viewController(forItem: Int)
    
}

public class API {
    
    public enum MenuFormat {
        case tab, dual, single
    }
    
    public static var items = [String]()
    
    public static func injectMenuStackIntoApp(window: UIWindow) {
        
    }
    
    public static func setMenuItems(_ : [String], format: MenuFormat, delegate: MenuItemsDelegate?) {
        
    }
    
}
