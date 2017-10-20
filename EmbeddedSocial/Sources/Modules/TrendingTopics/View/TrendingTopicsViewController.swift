//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

private let loadingIndicatorHeight: CGFloat = 44.0

class TrendingTopicsViewController: BaseViewController {
    
    weak var output: TrendingTopicsViewOutput!
    var dataManager: TrendingTopicsDataDisplayManager!
    
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
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    @objc private func onPullToRefresh() {
        output.onPullToRefresh()
    }
}

extension TrendingTopicsViewController: TrendingTopicsViewInput {
    
    func setupInitialState() {
        tableView.dataSource = dataManager
        tableView.delegate = dataManager
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)

        let cell = GroupHeaderTableCell.fromNib()
        cell.apply(style: .search)
        cell.configure(title: L10n.Search.Label.trendingTopics.uppercased())
        tableView.tableHeaderView = cell

        dataManager.onItemSelected = { [weak self] item in self?.output.onItemSelected(item) }
        dataManager.tableView = tableView
        
        apply(theme: theme)
    }
    
    func setHashtags(_ hashtags: [Hashtag]) {
        dataManager.setHashtags(hashtags)
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isLoading = isLoading
        tableView.tableFooterView = isLoading ? loadingIndicatorView : UIView()
    }
    
    func endPullToRefreshAnimation() {
        refreshControl.endRefreshing()
    }
}

extension TrendingTopicsViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        view.backgroundColor = palette.contentBackground
        tableView.backgroundColor = palette.contentBackground
        refreshControl.tintColor = palette.loadingIndicator
    }
}
