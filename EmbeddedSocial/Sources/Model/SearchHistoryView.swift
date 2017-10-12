//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchHistoryView: UIView {
    
    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        self.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.registerCells(for: tableView)
        return tableView
    }()
    
    var maxHeight = CGFloat.greatestFiniteMagnitude
    
    var searchRequests: [String] = [] {
        didSet {
            tableView.reloadData()
            updateHeight()
        }
    }
    
    var onSearchRequestSelected: ((String) -> Void)?
    
    private func updateHeight() {
        let contentHeight = tableView.contentSize.height
        var frame = self.frame
        frame.size.height = max(0.0, min(contentHeight, maxHeight))
        self.frame = frame
    }
    
    private func registerCells(for tableView: UITableView) {
        tableView.register(cellClass: UITableViewCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        _ = tableView
    }
}

extension SearchHistoryView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseID, for: indexPath)
        cell.textLabel?.text = searchRequests[indexPath.row]
        cell.textLabel?.textColor = AppConfiguration.shared.theme.palette.textPrimary
        cell.textLabel?.font = AppFonts.regular
        cell.backgroundColor = AppConfiguration.shared.theme.palette.contentBackground
        cell.imageView?.image = UIImage(asset: .iconRecentSearch)
        cell.imageView?.contentMode = .center
        return cell
    }
}

extension SearchHistoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSearchRequestSelected?(searchRequests[indexPath.row])
    }
}
