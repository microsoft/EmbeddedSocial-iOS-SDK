//
//  SideMenuSideMenuViewInput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol SideMenuViewInput: class {

    /**
        @author igor.popov
        Setup initial state of the view
    */

    func setupInitialState()
    func reload()
    func reload(section: Int)
    func showTabBar(visible: Bool)
    func showAccountInfo(visible: Bool)
}
