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
    func switchTab(to index: Int)
}

protocol ActivityViewOutput: class {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func viewIsReady()
    func cellIdentifier(for indexPath: IndexPath) -> String
    func headerForSection(_ section: Int) -> String
    func configure(_ cell: UITableViewCell, for tableView: UITableView, with indexPath: IndexPath)
    
    func loadAll()
    func loadMore()
    
    func didSwitchToTab(to index: Int)
}

class ActivityViewController: UIViewController {
    
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
        
        output.viewIsReady()
    }
    
    private func setup() {
        
        // Appearance
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        segmentControl.tintColor = Palette.green
        
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
    }
    
}

extension ActivityViewController: ActivityViewInput {
    
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
    
    func reloadItems(indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.reloadRows(at: indexes, with: .fade)
        tableView.endUpdates()
    }
    
    func addNewItems(indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexes, with: .fade)
        tableView.endUpdates()
    }
    
    func removeItems(indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.deleteRows(at: indexes, with: .fade)
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
        
        return cell
    }
    
}

extension ActivityViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isReachingEndOfContent(scrollView: scrollView) {
            output.loadMore()
        }
    }
    
    func isReachingEndOfContent(scrollView: UIScrollView) -> Bool {
        let contentLeft = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.bounds.height
        let cellsLeft = contentLeft / Style.cellSize
        return cellsLeft < 5
    }
    
}

