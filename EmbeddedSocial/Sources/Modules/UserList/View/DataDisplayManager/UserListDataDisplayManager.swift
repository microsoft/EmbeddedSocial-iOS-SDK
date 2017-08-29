//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

private let cellHeight: CGFloat = 66.0

final class UserListDataDisplayManager: NSObject, TableDataDisplayManager {
    typealias Section = SectionModel<Void, UserListItem>
    
    fileprivate var sections: [Section] = []
    
    var onItemAction: ((UserListItem) -> Void)?
    
    var onReachingEndOfContent: (() -> Void)?
    
    var onItemSelected: ((UserListItem) -> Void)?
    
    weak var tableView: UITableView!
    
    func tableDataSource(for tableView: UITableView) -> UITableViewDataSource? {
        return self
    }
    
    private let me: User?
    
    init(me: User?) {
        self.me = me
    }
    
    func setup(with users: [User]) {
        let builder = UserListItemsBuilder(me: me)
        sections = builder.makeSections(users: users, actionHandler: onItemAction)
        registerCells(for: tableView)
        tableView.reloadData()
    }
    
    func onItemAction(_ item: UserListItem) {
        onItemAction?(item)
    }
    
    func registerCells(for tableView: UITableView) {
        let items = sections.flatMap { $0.items }
        for item in items {
            tableView.register(cellClass: item.cellClass)
        }
    }
    
    var tableDelegate: UITableViewDelegate? {
        return self
    }
    
    func configuredCell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseID, for: indexPath)
        configure(cell: cell, with: item)
        return cell
    }
    
    private func configure(cell: UITableViewCell, with item: UserListItem) {        
        cell.selectionStyle = .none
        (cell as? UserListCell)?.configure(item)
    }
    
    func updateListItem(with user: User, at indexPath: IndexPath) {
        let builder = UserListItemsBuilder(me: me)
        sections = builder.updatedSections(with: user, at: indexPath, sections: sections)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func setIsLoading(_ isLoading: Bool, itemAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UserListCell {
            cell.isLoading = isLoading
        }
    }
    
    func isReachingEndOfContent(scrollView: UIScrollView) -> Bool {
        let contentLeft = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.bounds.height
        let cellsLeft = contentLeft / cellHeight
        return cellsLeft < CGFloat(Constants.UserList.pageSize) / 2.0
    }
}

extension UserListDataDisplayManager: UITableViewDataSource {
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

extension UserListDataDisplayManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onItemSelected?(sections[indexPath.section].items[indexPath.row])
    }
}

extension UserListDataDisplayManager: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isReachingEndOfContent(scrollView: scrollView) {
            onReachingEndOfContent?()
        }
    }
}
