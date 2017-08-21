//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchInteractor: SearchInteractorInput {
    private let isLoggedInUser: Bool
    
    init(isLoggedInUser: Bool) {
        self.isLoggedInUser = isLoggedInUser
    }
    
    func makePageInfo(from searchPeopleModule: SearchPeopleModuleInput) -> SearchPageInfo {
        return SearchPageInfo(searchResultsController: searchPeopleModule.searchResultsController(),
                              searchResultsHandler: searchPeopleModule.searchResultsHandler(),
                              backgroundView: isLoggedInUser ? searchPeopleModule.backgroundView() : nil)
    }
}
