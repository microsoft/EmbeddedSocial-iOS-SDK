//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchPeopleInteractor: SearchPeopleInteractorInput {
    
    private lazy var backgroudListModule: UserListModuleInput = { [unowned self] in
        let conf = UserListConfigurator()
        let api = SuggestedUsersAPI(socialService: SocialService())
        let module = conf.configure(api: api, output: nil)
        module.setupInitialState()
        module.setListHeaderView(self.makeListHeaderView())
        return module
    }()
    
    private func makeListHeaderView() -> UIView {
        let cell = GroupHeaderTableCell.fromNib()
        cell.apply(style: .peopleSearch)
        cell.configure(title: L10n.Search.Label.basedOnWhoYouFollow.uppercased())
        return cell
    }
    
    func runSearchQuery(for searchController: UISearchController, usersListModule: UserListModuleInput) {
        print(searchController.searchBar)
        guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        let api = QueryPeopleAPI(query: searchText, searchService: SearchService())
        usersListModule.reload(with: api)
    }
    
    func makeBackgroundView() -> UIView {
        return backgroudListModule.listView
    }
}
