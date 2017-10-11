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
        self.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.registerCells(for: tableView)
        return tableView
    }()
    
    var searchRequests: [String] = []
    
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
        backgroundColor = .clear
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
        return cell
    }
}

extension SearchHistoryView: UITableViewDelegate {
    
}
