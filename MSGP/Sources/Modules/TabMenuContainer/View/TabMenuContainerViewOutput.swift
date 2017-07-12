//
//  TabMenuContainerTabMenuContainerViewOutput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol TabMenuContainerViewOutput {

    /**
        @author igor.popov
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func didSelect(tab: TabMenuContainerTabs)
}
