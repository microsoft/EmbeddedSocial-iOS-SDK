//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class SearchPeopleInteractor: SearchPeopleInteractorInput {
    
    func makeBackgroundListHeaderView() -> UIView {
        let cell = GroupHeaderTableCell.fromNib()
        cell.apply(style: .search)
        cell.configure(title: L10n.Search.Label.basedOnWhoYouFollow.uppercased())
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.standardCellHeight)
        cell.frame = frame
        
        let tableHeaderView = UITableViewHeaderFooterView(frame: frame)
        tableHeaderView.contentView.addSubview(cell)
        return tableHeaderView
    }
    
    func runSearchQuery(for searchBar: UISearchBar, usersListModule: UserListModuleInput) {
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces), !searchText.isEmpty else {
            return
        }
        let api = QueryPeopleAPI(query: searchText, searchService: SearchService())
        usersListModule.reload(with: api)
    }
}
