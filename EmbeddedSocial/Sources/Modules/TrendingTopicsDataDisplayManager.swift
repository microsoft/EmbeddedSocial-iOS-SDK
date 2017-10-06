//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

private let cellHeight: CGFloat = Constants.standardCellHeight

final class TrendingTopicsDataDisplayManager: NSObject, TableDataDisplayManager {
    typealias Section = SectionModel<Void, TrendingTopicsListItem>
    
    var onItemSelected: ((TrendingTopicsListItem) -> Void)?
    
    weak var tableView: UITableView?
        
    fileprivate var sections: [Section] = []
    
    func setHashtags(_ hashtags: [Hashtag]) {
        let items = hashtags.map(TrendingTopicsListItem.init)
        sections = [Section(model: (), items: items)]
        if let tableView = tableView {
            registerCells(for: tableView)
        }
        tableView?.reloadData()
    }

    func tableDataSource(for tableView: UITableView) -> UITableViewDataSource? {
        return self
    }
    
    var tableDelegate: UITableViewDelegate? {
        return self
    }
    
    func registerCells(for tableView: UITableView) {
        let items = sections.flatMap { $0.items }
        for item in items {
            tableView.register(cellClass: item.cellClass)
        }
    }
    
    fileprivate func configuredCell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseID, for: indexPath)
        configure(cell: cell, with: item)
        return cell
    }
    
    private func configure(cell: UITableViewCell, with item: TrendingTopicsListItem) {
        cell.selectionStyle = .none
        cell.textLabel?.text = item.hashtag
    }
}

extension TrendingTopicsDataDisplayManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onItemSelected?(sections[indexPath.section].items[indexPath.row])
    }
}

extension TrendingTopicsDataDisplayManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configuredCell(tableView: tableView, at: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}
