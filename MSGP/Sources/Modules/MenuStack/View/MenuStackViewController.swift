//
//  MenuStackMenuStackViewController.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class MenuStackViewController: UIViewController, MenuStackViewInput {

    var output: MenuStackViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: MenuStackViewInput
    func setupInitialState() {
    }
}
