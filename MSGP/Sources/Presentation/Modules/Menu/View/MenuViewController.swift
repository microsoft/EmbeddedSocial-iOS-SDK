//
//  MenuMenuViewController.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, MenuViewInput {

    var output: MenuViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: MenuViewInput
    func setupInitialState() {
    }
}
