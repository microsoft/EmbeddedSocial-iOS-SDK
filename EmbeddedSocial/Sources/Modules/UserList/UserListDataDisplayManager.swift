//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UserListItem {
    let userID: String
    let fullName: String
    let buttonStyle: UIButton.Style
    let action: ((String) -> Void)?
}

extension UserListItem: CellModel {
    var cellClass: UITableViewCell.Type {
        return UITableViewCell.self
    }
    
    var reuseID: String {
        return ""
    }
}

final class UserListDataDisplayManager: NSObject, TableDataDisplayManager {
    typealias Section = SectionModel<Void, UserListItem>
    
    fileprivate var sections: [Section]!
    
    var users: [User] = []
    
    func tableDataSource(for tableView: UITableView) -> UITableViewDataSource? {
        if sections == nil {
            setup(tableView: tableView, with: users)
        }
        
        return self
    }
    
    func setup(tableView: UITableView, with users: [User]) {
        sections = makeSections()
        registerCells(for: tableView)
    }
    
    private func makeSections() -> [Section] {
        return []
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // https://stackoverflow.com/a/22173707/6870041 workaround
        DispatchQueue.main.async {
//            self.onSelectPhoto?()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.standardCellHeight
    }
}
