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
    
    var dataManager: CreateAccountDataDisplayManager!
    
    var output: CreateAccountViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    func setupInitialState() {
        dataManager.tableView = tableView
        
        tableView.dataSource = dataManager.tableDataSource(for: tableView)
        tableView.delegate = dataManager.tableDelegate
        tableView.tableFooterView = UIView()
        
//        dataManager.onLastNameChanged = { () }
//        dataManager.onFirstNameChanged = { () }
//        dataManager.onBioChanged = { () }
    }
}
