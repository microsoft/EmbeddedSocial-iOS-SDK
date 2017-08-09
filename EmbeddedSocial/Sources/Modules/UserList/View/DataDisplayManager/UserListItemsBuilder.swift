//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UserListItemsBuilder {
    typealias Section = UserListDataDisplayManager.Section
    
    private let me: User
    
    init(me: User) {
        self.me = me
    }
    
    func makeSections(users: [User], actionHandler: @escaping (UserListItem) -> Void) -> [Section] {
        let items = users.enumerated().map { pair -> UserListItem in
            let user = pair.element.uid == self.me.uid ? self.me : pair.element
            return UserListItem(user: user, indexPath: IndexPath(row: pair.offset, section: 0), action: actionHandler)
        }
        
        return [Section(model: (), items: items)]
    }
    
    func updatedSections(with user: User, at indexPath: IndexPath, sections: [Section]) -> [Section] {
        var sections = sections
        
        let section = sections[indexPath.section]
        
        var items = section.items
        let itemToReplace = items[indexPath.row]
        items[indexPath.row] = UserListItem(user: user, indexPath: indexPath, action: itemToReplace.action)
        
        sections[indexPath.section] = Section(model: section.model, items: items)
        
        return sections
    }
}
