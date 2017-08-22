//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

final class MockSearchPeopleInteractor: SearchPeopleInteractorInput {
    private(set) var makeBackgroundListHeaderViewCount = 0
    var backgroundListHeaderView = UIView()
    
    private(set) var runSearchQueryCount = 0
    private(set) var runSearchQueryParams: (UISearchController, UserListModuleInput)?
    let runSearchQueryExpectation = XCTestExpectation()
    
    func runSearchQuery(for searchController: UISearchController, usersListModule: UserListModuleInput) {
        runSearchQueryParams = (searchController, usersListModule)
        runSearchQueryCount += 1
        runSearchQueryExpectation.fulfill()
    }
    
    func makeBackgroundListHeaderView() -> UIView {
        makeBackgroundListHeaderViewCount += 1
        return backgroundListHeaderView
    }
}
