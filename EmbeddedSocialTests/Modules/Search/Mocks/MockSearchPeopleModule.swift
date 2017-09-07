//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockSearchPeopleModule: SearchPeopleModuleInput {
    private(set) var setupInitialStateCount = 0
    
    var searchResultsHandlerToReturn = MockSearchResultsUpdating()
    var searchResultsControllerToReturn = UIViewController()
    var backgroundViewToReturn: UIView?

    func setupInitialState() {
        setupInitialStateCount += 1
    }
    
    func searchResultsHandler() -> SearchResultsUpdating {
        return searchResultsHandlerToReturn
    }
    
    func backgroundView() -> UIView? {
        return backgroundViewToReturn
    }
    
    func searchResultsController() -> UIViewController {
        return searchResultsControllerToReturn
    }
}
