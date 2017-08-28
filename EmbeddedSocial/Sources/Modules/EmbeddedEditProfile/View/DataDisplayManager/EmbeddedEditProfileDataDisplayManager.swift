 //
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class EmbeddedEditProfileDataDisplayManager: NSObject, TableDataDisplayManager {
    typealias Section = SectionModel<EmbeddedEditProfileGroupHeader?, EmbeddedEditProfileItem>
    typealias TextChangedHandler = (String?) -> Void
    
    fileprivate let groupHeaderCellClass = GroupHeaderTableCell.self
    
    fileprivate(set) var sections: [Section] = []
    
    fileprivate weak var tableView: UITableView?
    
    fileprivate var bioText: String?
    
    var onFirstNameChanged: TextChangedHandler?
    var onLastNameChanged: TextChangedHandler?
    var onBioChanged: TextChangedHandler?
    var onSelectPhoto: (() -> Void)?
    
    private lazy var builder: EmbeddedEditProfileCellsBuilder = { [unowned self] in
        var builder = EmbeddedEditProfileCellsBuilder()
        builder.onFirstNameChanged = { self.onFirstNameChanged?($0) }
        builder.onLastNameChanged = { self.onLastNameChanged?($0) }
        builder.onBioChanged = {
            self.onBioChanged?($0)
            self.bioText = $0
        }
        builder.onBioLinesCountChanged = {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
        return builder
    }()
    
    fileprivate let prototypeTextViewCell = TextViewCell()
    
    func tableDataSource(for tableView: UITableView) -> UITableViewDataSource? {
        return self
    }
    
    func setup(with tableView: UITableView, user: User) {
        self.tableView = tableView
        sections = builder.makeSections(user: user)
        setupTableWithSections(tableView, sections: sections)
    }
    
    private func setupTableWithSections(_ tableView: UITableView, sections: [Section]) {
        registerCells(for: tableView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    func registerCells(for tableView: UITableView) {
        let items = sections.flatMap { $0.items }
        for item in items {
            tableView.register(cellClass: item.cellClass)
        }
        tableView.register(cellClass: groupHeaderCellClass) // for group header
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
    
    private func configure(cell: UITableViewCell, with item: EmbeddedEditProfileItem) {
        cell.selectionStyle = .none
        
        switch item {
        case let .uploadPhoto(photo):
            (cell as? UploadPhotoCell)?.configure(photo: photo)
            cell.accessibilityIdentifier = "Photo"
        case .firstName(let style):
            (cell as? TextFieldCell)?.apply(style: style)
            cell.accessibilityIdentifier = "First Name"
        case .lastName(let style):
            (cell as? TextFieldCell)?.apply(style: style)
            cell.accessibilityIdentifier = "Last Name"
        case let .bio(style):
            (cell as? TextViewCell)?.apply(style: style)
            cell.accessibilityIdentifier = "Bio"
        }
    }
}

extension EmbeddedEditProfileDataDisplayManager: UITableViewDataSource {
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

extension EmbeddedEditProfileDataDisplayManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .uploadPhoto = sections[indexPath.section].items[indexPath.row] else {
            return
        }
        // https://stackoverflow.com/a/22173707/6870041 workaround
        DispatchQueue.main.async {
            self.onSelectPhoto?()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = sections[section].model,
            case let .accountInformation(style, title) = model,
            let header = tableView.dequeueReusableCell(
                withIdentifier: groupHeaderCellClass.reuseID) as? GroupHeaderTableCell else {
                    return nil
        }
        header.configure(title: title)
        header.apply(style: style)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].model != nil ? Constants.standardCellHeight : 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case .uploadPhoto:
            return Constants.EditProfile.uploadPhotoHeight
        case .firstName, .lastName:
            return Constants.standardCellHeight
        case .bio:
            return UITableViewAutomaticDimension
        }
    }
}
