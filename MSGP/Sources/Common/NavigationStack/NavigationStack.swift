//
//  File.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

class NavigationStack {
    
    var navigationController: UINavigationController?
    var menu: UIViewController?
    var container: UIViewController?
    
    init(window: UIWindow) {
        window.rootViewController = navigationController;
    }
    
    
}
