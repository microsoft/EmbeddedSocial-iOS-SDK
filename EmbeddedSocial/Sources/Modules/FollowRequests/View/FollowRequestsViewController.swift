//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

private let loadingIndicatorHeight: CGFloat = 44.0
private let navBarAndStatusBarHeight: CGFloat = 64

class FollowRequestsViewController: BaseViewController {
    
    var output: FollowRequestsViewOutput!
    
    var dataManager: FollowRequestsDataDisplayManager! {
        didSet {
            dataManager.onItemSelected = { [weak self] in self?.output.onItemSelected($0) }
            dataManager.onRejectRequest = { [weak self] in self?.output.onReject($0) }
            dataManager.onAcceptRequest = { [weak self] in self?.output.onAccept($0) }
            dataManager.onReachingEndOfContent = { [weak self] in self?.output.onReachingEndOfPage() }
        }
    }
    
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.addSubview(refreshControl)
        }
    }
    
    @IBOutlet fileprivate weak var noDataLabel: UILabel! {
        didSet {
            noDataLabel.isHidden = true
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apply(theme: theme)
        output.viewIsReady()
    }
    
    @objc private func onPullToRefresh() {
        output.onPullToRefresh()
    }
}

extension FollowRequestsViewController: FollowRequestsViewInput {
    func setupInitialState() {
        dataManager.tableView = tableView
        tableView.delegate = dataManager.tableDelegate
        tableView.dataSource = dataManager.tableDataSource(for: tableView)
    }
    
    func setUsers(_ users: [User]) {
        dataManager.setup(with: users)
    }
    
    func setIsLoading(_ isLoading: Bool, item: FollowRequestItem) {
        dataManager.setIsLoading(isLoading, user: item.user)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isLoading = isLoading
        tableView.tableFooterView = isLoading ? loadingIndicatorView : UIView()
    }
    
    func removeUser(_ user: User) {
        dataManager.removeUser(user)
    }
    
    func endPullToRefreshAnimation() {
        refreshControl.endRefreshing()
    }
    
    func setIsEmpty(_ isEmpty: Bool) {
        noDataLabel.isHidden = !isEmpty
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setNoDataText(_ text: NSAttributedString?) {
        noDataLabel.attributedText = text
    }
}

extension FollowRequestsViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        view.backgroundColor = palette.contentBackground
        refreshControl.tintColor = palette.loadingIndicator
        tableView.backgroundColor = palette.contentBackground
        noDataLabel.textColor = palette.textPrimary
        
    }
}
























