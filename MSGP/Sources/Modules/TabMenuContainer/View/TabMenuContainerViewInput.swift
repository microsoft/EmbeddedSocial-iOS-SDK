//
//  TabMenuContainerTabMenuContainerViewInput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol TabMenuContainerViewInput: class {

    /**
        @author igor.popov
        Setup initial state of the view
    */
    
    func setupInitialState()
    
    func select(tab: TabMenuContainerTabs)
    func show(tab: UIViewController)
}
