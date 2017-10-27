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
        return cell
    }
    
    func runSearchQuery(for searchBar: UISearchBar, usersListModule: UserListModuleInput) {
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces), !searchText.isEmpty else {
            return
        }
        let api = QueryPeopleAPI(query: searchText, searchService: SearchService())
        usersListModule.reload(with: api)
    }
}
