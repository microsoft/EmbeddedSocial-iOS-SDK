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
    
    @IBOutlet fileprivate weak var loadingView: LoadingIndicatorView!
    
    var dataManager: CreateAccountDataDisplayManager!
    
    var output: CreateAccountViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    func setupInitialState(with user: SocialUser) {
        setupNavBar()
        
        loadingView.apply(style: .standard)
        
        dataManager.update(tableView: tableView, with: user)
        
        tableView.dataSource = dataManager.tableDataSource(for: tableView)
        tableView.delegate = dataManager.tableDelegate
        tableView.tableFooterView = UIView()
        
        dataManager.onLastNameChanged = { [weak self] text in self?.output.onLastNameChanged(text) }
        dataManager.onFirstNameChanged = { [weak self] text in self?.output.onFirstNameChanged(text) }
        dataManager.onBioChanged = { [weak self] text in self?.output.onBioChanged(text) }
        dataManager.onSelectPhoto = { [weak self] in self?.output.onSelectPhoto() }
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign up",
            style: .plain,
            target: self,
            action: #selector(self.signIn)
        )
    }
    
    func signIn() {
        output.onCreateAccount()
    }
    
    func setUser(_ user: SocialUser) {
        dataManager.update(tableView: tableView, with: user)
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingView.isHidden = !isLoading
        loadingView.isLoading = isLoading
        tableView.isHidden = isLoading
    }
    
    func setCreateAccountButtonEnabled(_ isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
}
