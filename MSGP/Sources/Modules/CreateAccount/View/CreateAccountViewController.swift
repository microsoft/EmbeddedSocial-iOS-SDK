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

    func setupInitialState(with user: User) {
        dataManager.update(tableView: tableView, with: user)
        
        tableView.dataSource = dataManager.tableDataSource(for: tableView)
        tableView.delegate = dataManager.tableDelegate
        tableView.tableFooterView = UIView()
        
        dataManager.onLastNameChanged = { [weak self] text in self?.output.onLastNameChanged(text) }
        dataManager.onFirstNameChanged = { [weak self] text in self?.output.onFirstNameChanged(text) }
        dataManager.onBioChanged = { [weak self] text in self?.output.onBioChanged(text) }
        dataManager.onSelectPhoto = { [weak self] in self?.output.onSelectPhoto() }
    }
    
    func setUser(_ user: User) {
        dataManager.update(tableView: tableView, with: user)
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
}
