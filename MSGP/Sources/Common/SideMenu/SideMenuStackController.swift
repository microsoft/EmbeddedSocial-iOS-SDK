//
//  MenuStackController.swift
//  MSGP
//
//  Created by Igor Popov on 7/17/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import SlideMenuControllerSwift

protocol SideMenuStackControllerProtocol {
    
    func closeSideMenu()
    func openSideMenu()
    
}

@objc class MenuStackController: SlideMenuController, SideMenuStackControllerProtocol {
    
    func closeSideMenu() {
        closeLeft()
    }
    
    func openSideMenu() {
        openLeft()
    }
    
}
