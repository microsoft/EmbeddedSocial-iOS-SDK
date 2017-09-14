//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

private let loadingIndicatorHeight: CGFloat = 44.0

class UserListView: UIView {
    
    weak var output: UserListViewOutput!
    
    var dataManager: UserListDataDisplayManager! {
        didSet {
            dataManager.onItemAction = { [weak self] in self?.output.onItemAction(item: $0) }
            dataManager.onReachingEndOfContent = { [weak self] in self?.output.onReachingEndOfPage() }
            dataManager.onItemSelected = { [weak self] in self?.output.onItemSelected($0) }
            dataManager.tableView = tableView
        }
    }
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.delegate = self.dataManager.tableDelegate
        tableView.dataSource = self.dataManager.tableDataSource(for: tableView)
        tableView.tableFooterView = UIView()
        tableView.accessibilityIdentifier = "UserList"
        self.addSubview(tableView)
        tableView.addSubview(self.refreshControl)
        return tableView
    }()
    
    fileprivate lazy var loadingIndicatorView: LoadingIndicatorView = { [unowned self] in
        let frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: loadingIndicatorHeight)
        let view = LoadingIndicatorView(frame: frame)
        view.apply(style: .standard)
        return view
    }()
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        refreshControl.tintColor = Palette.lightGrey
        return refreshControl
    }()
    
    fileprivate lazy var noDataLabel: UILabel = { [unowned self] in
        let label = UILabel()
        self.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func onPullToRefresh() {
        output.onPullToRefresh()
    }
}

extension UserListView: UserListViewInput {
    
    func updateListItem(with user: User) {
        dataManager.updateListItem(with: user)
    }
    
    func setIsLoading(_ isLoading: Bool, item: UserListItem) {
        dataManager.setIsLoading(isLoading, user: item.user)
    }
    
    func setupInitialState() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        let navBarAndStatusBarHeight: CGFloat = 64
        noDataLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-navBarAndStatusBarHeight)
        }
    }
    
    func setUsers(_ users: [User]) {
        dataManager.setup(with: users)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isLoading = isLoading
        if isLoading {
            tableView.tableFooterView = loadingIndicatorView
        } else {
            tableView.tableFooterView = UIView()
        }
    }
    
    func setListHeaderView(_ view: UIView?) {
        tableView.tableHeaderView = view
    }
    
    func removeUser(_ user: User) {
        dataManager.removeUser(user)
    }
    
    func endPullToRefreshAnimation() {
        refreshControl.endRefreshing()
    }
    
    func setNoDataText(_ text: NSAttributedString?) {
        noDataLabel.attributedText = text
    }
}
