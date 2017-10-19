//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

private let loadingIndicatorHeight: CGFloat = 44.0
private let navBarAndStatusBarHeight: CGFloat = 64

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
    
    var anyItemsShown: Bool {
        return !tableView.visibleCells.isEmpty
    }
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.delegate = self.dataManager.tableDelegate
        tableView.dataSource = self.dataManager.tableDataSource(for: tableView)
        tableView.tableFooterView = UIView()
        tableView.accessibilityIdentifier = "UserList"
        self.addSubview(tableView)
        tableView.addSubview(self.refreshControl)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        return refreshControl
    }()
    
    fileprivate lazy var noDataLabel: UILabel = { [unowned self] in
        let label = UILabel()
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-navBarAndStatusBarHeight)
        }
        return label
    }()
    
    weak fileprivate var noDataView: UIView?
    
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
        apply(theme: theme)
    }
    
    func setUsers(_ users: [User]) {
        dataManager.setup(with: users)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isLoading = isLoading
        tableView.tableFooterView = isLoading ? loadingIndicatorView : UIView()
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
    
    func setNoDataView(_ view: UIView?) {
        noDataView = view
        
        guard let view = view else {
            return
        }
        tableView.addSubview(view)
        view.snp.makeConstraints { make in
            make.size.equalTo(self.tableView)
            make.centerX.equalTo(self.tableView)
            make.centerY.equalTo(self.tableView).offset(-navBarAndStatusBarHeight)
        }
    }
    
    func setIsEmpty(_ isEmpty: Bool) {
        noDataLabel.isHidden = !isEmpty
        noDataView?.isHidden = !isEmpty
    }
}

extension UserListView: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        tableView.backgroundColor = palette.contentBackground
        refreshControl.tintColor = palette.loadingIndicator
        noDataLabel.textColor = palette.textPrimary
    }
}

