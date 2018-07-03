//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

private let cellHeight: CGFloat = 66.0

final class UserListDataDisplayManager: NSObject, TableDataDisplayManager {
    typealias Section = SectionModel<Void, UserListItem>
    
    fileprivate var sections: [Section] = []
    
    var onItemAction: ((UserListItem) -> Void)?
    
    var onReachingEndOfContent: (() -> Void)?
    
    var onItemSelected: ((UserListItem) -> Void)?
    
    var theme: Theme?
    
    weak var tableView: UITableView!
    
    func tableDataSource(for tableView: UITableView) -> UITableViewDataSource? {
        return self
    }
    
    private let myProfileHolder: UserHolder
    private var users: [User] = []
    private let builder: UserListItemsBuilder
    
    init(myProfileHolder: UserHolder, builder: UserListItemsBuilder) {
        self.myProfileHolder = myProfileHolder
        self.builder = builder
    }
    
    func setup(with users: [User]) {
        self.users = users
        builder.me = myProfileHolder.me
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
        (cell as? UserListCell)?.apply(theme: theme)
    }
    
    func updateListItem(with user: User) {
        guard let indexPath = indexPath(for: user) else {
            return
        }
        builder.me = myProfileHolder.me
        sections = builder.updatedSections(with: user, at: indexPath, sections: sections)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func indexPath(for user: User) -> IndexPath? {
        guard let index = users.index(where: { $0.uid == user.uid }) else {
            return nil
        }
        return IndexPath(row: index, section: 0)
    }
    
    func setIsLoading(_ isLoading: Bool, user: User) {
        if let indexPath = indexPath(for: user), let cell = tableView.cellForRow(at: indexPath) as? UserListCell {
            cell.isLoading = isLoading
        }
    }
    
    func isReachingEndOfContent(scrollView: UIScrollView) -> Bool {
        return scrollView.isReachingEndOfContent(cellHeight: cellHeight, cellsPerPage: Constants.UserList.pageSize)
    }
    
    func removeUser(_ user: User) {
        guard let indexPath = indexPath(for: user) else {
            return
        }
        users.remove(at: indexPath.row)
        setup(with: users)
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
