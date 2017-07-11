//
//  MenuMenuRouterInput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import Foundation

enum MenuNavigation {
    case home, search, popular, pins, feed, settings, logout
}


protocol MenuRouterInput {
    
    func openMenu(_ : MenuNavigation)

}
