//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol ActivityViewInput: class {
    func setupInitialState()
    func registerCell(cell: UITableViewCell.Type, id: String)
    func showError(_ error: Error)
    func addNewItems(indexes: [IndexPath])
    func removeItems(indexes: [IndexPath])
    func reloadItems(indexes: [IndexPath])
    func reloadItems()
    func updateVisible()
    func switchTab(to index: Int)
    
    func resetLoading()
    func loadingDidStart()
    func loadingDidFinish()
}

protocol ActivityViewOutput: class {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func viewIsReady()
    func cellIdentifier(for indexPath: IndexPath) -> String
    func headerForSection(_ section: Int) -> String
    func configure(_ cell: UITableViewCell, for tableView: UITableView, with indexPath: IndexPath)
    
    func loadAll()
    func loadMore(section: Int)
    
    func didSwitchToTab(to index: Int)
    
    func viewWillAppear()
}

class ActivityViewController: BaseViewController {
    struct Style {
        static let cellSize = CGFloat(80)
    }
    
    var output: ActivityViewOutput!
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var segmentControl: UISegmentedControl!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        apply(theme: theme)

        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    private func setup() {
        
        title = "Activity Feed"
        
        // Appearance
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.accessibilityIdentifier = "ActivityFeed"
        tableView.delegate = self
        
        tableView.addSubview(self.refreshControl)
    }
    
    @IBAction func segmentControlDidChange(_ sender: UISegmentedControl) {
        output.didSwitchToTab(to: sender.selectedSegmentIndex)
    }
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)
        refreshControl.tintColor = Palette.lightGrey
        return refreshControl
    }()
    
    @objc private func didPullRefresh() {
        output.loadAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
}

extension ActivityViewController: ActivityViewInput {
    
    func resetLoading() {
        Logger.log()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func loadingDidStart() {
        Logger.log()
    }
    
    func loadingDidFinish() {
        Logger.log()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func switchTab(to index: Int) {
        segmentControl.selectedSegmentIndex = index
    }

    func reloadItems() {
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        Logger.log(error, event: .veryImportant)
    }
    
    func setupInitialState() {
        
    }
    
    func registerCell(cell: UITableViewCell.Type, id: String) {
        tableView.register(cell, forCellReuseIdentifier: id)
    }
    
    func updateVisible() {
        if let paths = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: paths, with: .automatic)
        }
    }
    
    func reloadItems(indexes: [IndexPath]) {
        tableView.reloadRows(at: indexes, with: .automatic)
    }
    
    func addNewItems(indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    func removeItems(indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.deleteRows(at: indexes, with: .automatic)
        tableView.endUpdates()
    }
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Style.cellSize
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return output.headerForSection(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return output.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = output.cellIdentifier(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        output.configure(cell, for: tableView, with: indexPath)
        
        // check if its last item in section
        let index = indexPath.row
        let section = indexPath.section
        
        if index == output.numberOfItems(in: section) - 1 {
//            output.loadMore(section: section)
        }
        
        return cell
    }
}

extension ActivityViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        view.backgroundColor = palette.contentBackground
        tableView.backgroundColor = palette.contentBackground
        refreshControl.tintColor = palette.loadingIndicator
        segmentControl.apply(theme: theme)
    }
}

