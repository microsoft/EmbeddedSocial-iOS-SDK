//
//  CreateAccountDataDisplayManager.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class CreateAccountDataDisplayManager: NSObject, TableDataDisplayManager {
    typealias Section = SectionModel<String?, CreateAccountItem>
    typealias TextChangedHandler = (String?) -> Void

    fileprivate let user: SocialUser
    fileprivate(set) var sections: [Section]!
    
    weak var tableView: UITableView?
    
    fileprivate var bioText: String?
    
    var onFirstNameChanged: TextChangedHandler?
    var onLastNameChanged: TextChangedHandler?
    var onBioChanged: TextChangedHandler?
    
    private lazy var builder: CreateAccountCellModelsBuilder = { [unowned self] in
        var builder = CreateAccountCellModelsBuilder()
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
    
    init(user: SocialUser) {
        self.user = user
        super.init()
    }
    
    func tableDataSource(for tableView: UITableView) -> UITableViewDataSource? {
        if sections == nil {
            sections = builder.makeSections(user: user, tableView: tableView)
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 44
        }
        return self
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
    
    private func configure(cell: UITableViewCell, with item: CreateAccountItem) {
        switch item {
        case let .uploadPhoto(photo):
            (cell as? UploadPhotoCell)?.configure(photo: photo)
        case .firstName(let style), .lastName(let style):
            (cell as? TextFieldCell)?.apply(style: style)
        case let .bio(style):
            (cell as? TextViewCell)?.apply(style: style)
        }
    }
}

extension CreateAccountDataDisplayManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configuredCell(tableView: tableView, at: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].model
    }
}

extension CreateAccountDataDisplayManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case .uploadPhoto:
            return Constants.createAccountUploadPhotoHeight
        case .firstName, .lastName:
            return Constants.standardCellHeight
        case .bio:
            return UITableViewAutomaticDimension
        }
    }
}
