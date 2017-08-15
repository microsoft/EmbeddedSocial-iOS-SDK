//
//  EmbeddedEditProfileViewController.swift
//  EmbeddedSocial
//
//  Created by Vadim Bulavin on 8/15/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit
import SnapKit

class EmbeddedEditProfileView: UIView {
    
    weak var output: EmbeddedEditProfileViewOutput!
    var dataManager: EmbeddedEditProfileDataDisplayManager!
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return tableView
    }()
    
    fileprivate lazy var loadingView: LoadingIndicatorView = { [unowned self] in
        let loadingView = LoadingIndicatorView()
        loadingView.apply(style: .standard)
        self.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.EditProfile.contentPadding)
            make.right.equalToSuperview().offset(-Constants.EditProfile.contentPadding)
            make.height.equalTo(Constants.standardCellHeight)
        }
        return loadingView
    }()
}

extension EmbeddedEditProfileView: EmbeddedEditProfileViewInput {
    
    func setupInitialState(with user: User) {
        dataManager.setup(with: tableView, user: user)
        
        tableView.dataSource = dataManager.tableDataSource(for: tableView)
        tableView.delegate = dataManager.tableDelegate
        
        dataManager.onLastNameChanged = { [weak self] text in self?.output.onLastNameChanged(text) }
        dataManager.onFirstNameChanged = { [weak self] text in self?.output.onFirstNameChanged(text) }
        dataManager.onBioChanged = { [weak self] text in self?.output.onBioChanged(text) }
        dataManager.onSelectPhoto = { [weak self] in self?.output.onSelectPhoto() }
    }
    
    func setUser(_ user: User) {
        dataManager.setup(with: tableView, user: user)
        tableView.reloadData()
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingView.isHidden = !isLoading
        loadingView.isLoading = isLoading
        tableView.isHidden = isLoading
    }
}
