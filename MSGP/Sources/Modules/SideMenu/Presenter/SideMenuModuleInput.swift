//
//  SideMenuSideMenuModuleInput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol SideMenuModuleInput: class {
    
    func showUser(user: User)
    func open(viewController: UIViewController)
    
}
