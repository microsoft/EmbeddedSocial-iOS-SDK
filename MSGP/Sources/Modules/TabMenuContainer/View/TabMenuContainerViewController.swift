//
//  TabMenuContainerTabMenuContainerViewController.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class TabMenuContainerViewController: UIViewController, TabMenuContainerViewInput {
    
    func select(tab: TabMenuContainerTabs) {
        
    }
    
    func show(tab: UIViewController) {
        
    }

    var output: TabMenuContainerViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: TabMenuContainerViewInput
    func setupInitialState() {
        
    }
}
