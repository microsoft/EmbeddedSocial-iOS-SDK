//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class FollowingRouter: FollowingRouterInput {
    
    private weak var searchPeopleOpener: SearchPeopleOpener?
    private let navigationController: UINavigationController?
    
    init(searchPeopleOpener: SearchPeopleOpener?, navigationController: UINavigationController?) {
        self.searchPeopleOpener = searchPeopleOpener
        self.navigationController = navigationController
    }
    
    func openSuggestedUsers(authorization: Authorization) {
        let configurator = SuggestedUsersConfigurator()
        configurator.configure(authorization: authorization, navigationController: navigationController)
        navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openSearchPeople() {
        searchPeopleOpener?.openSearchPeople()
    }
}
