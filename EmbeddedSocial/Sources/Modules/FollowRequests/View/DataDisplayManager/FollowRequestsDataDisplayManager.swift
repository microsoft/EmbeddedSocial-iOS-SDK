//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

private let cellHeight: CGFloat = 66.0

final class FollowRequestsDataDisplayManager: NSObject {
    typealias Section = SectionModel<Void, FollowRequestItem>
    
    fileprivate var sections: [Section] = []
    
    var onAcceptRequest: ((FollowRequestItem) -> Void)?
    var onRejectRequest: ((FollowRequestItem) -> Void)?
    var onReachingEndOfContent: (() -> Void)?
    var onItemSelected: ((FollowRequestItem) -> Void)?
        
    weak var tableView: UITableView!
    
    private var users: [User] = []
    private let builder = FollowRequestItemsBuilder()
    
    func setup(with users: [User]) {
        self.users = users
        sections = builder.makeSections(users: users)
        registerCells(for: tableView)
        tableView.reloadData()
    }

    func configuredCell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseID, for: indexPath)
        configure(cell: cell, with: item)
        return cell
    }
    
    private func configure(cell: UITableViewCell, with item: FollowRequestItem) {
        guard let cell = cell as? FollowRequestCell else {
            return
        }
        cell.selectionStyle = .none
        cell.configure(item: item, tableView: tableView) { [weak self] indexPath, action in
            self?.onItemAction(indexPath: indexPath, action: action)
        }
    }
    
    private func onItemAction(indexPath: IndexPath, action: ActivityCellEvent) {
        guard indexPath.section >= 0 && indexPath.section < sections.count,
            indexPath.row >= 0 && indexPath.row < sections[indexPath.section].items.count else {
                return
        }

        let item = sections[indexPath.section].items[indexPath.row]
        
        switch action {
        case .accept:
            onAcceptRequest?(item)
        case .reject:
            onRejectRequest?(item)
        default:
            break
        }
    }
    
    func indexPath(for user: User) -> IndexPath? {
        guard let index = users.index(where: { $0.uid == user.uid }) else {
            return nil
        }
        return IndexPath(row: index, section: 0)
    }
    
    func setIsLoading(_ isLoading: Bool, user: User) {
        if let indexPath = indexPath(for: user),
            let cell = tableView.cellForRow(at: indexPath) as? FollowRequestCell {
            cell.isLoading = isLoading
        }
    }
    
    func isReachingEndOfContent(scrollView: UIScrollView) -> Bool {
        return scrollView.isReachingEndOfContent(cellHeight: cellHeight, cellsPerPage: Constants.FollowRequests.pageSize)
    }
    
    func removeUser(_ user: User) {
        guard let indexPath = indexPath(for: user) else {
            return
        }
        users.remove(at: indexPath.row)
        setup(with: users)
    }
}

extension FollowRequestsDataDisplayManager: UITableViewDataSource {
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

extension FollowRequestsDataDisplayManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onItemSelected?(sections[indexPath.section].items[indexPath.row])
    }
}

extension FollowRequestsDataDisplayManager: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isReachingEndOfContent(scrollView: scrollView) {
            onReachingEndOfContent?()
        }
    }
}

extension FollowRequestsDataDisplayManager: TableDataDisplayManager {
    
    func registerCells(for tableView: UITableView) {
        let items = sections.flatMap { $0.items }
        for item in items {
            tableView.register(cellClass: item.cellClass)
        }
    }

    func tableDataSource(for tableView: UITableView) -> UITableViewDataSource? {
        return self
    }
    
    var tableDelegate: UITableViewDelegate? {
        return self
    }
}
