//
//  CreateAccountViewController.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, CreateAccountViewInput {

    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var output: CreateAccountViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    func setupInitialState() {
        
    }
}
