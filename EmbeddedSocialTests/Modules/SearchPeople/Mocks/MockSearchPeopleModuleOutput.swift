//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockSearchPeopleModuleOutput: SearchPeopleModuleOutput {
    
    //MARK: - didFailToLoadSuggestedUsers
    
    var didFailToLoadSuggestedUsersCalled = false
    var didFailToLoadSuggestedUsersReceivedError: Error?
    
    func didFailToLoadSuggestedUsers(_ error: Error) {
        didFailToLoadSuggestedUsersCalled = true
        didFailToLoadSuggestedUsersReceivedError = error
    }
    
    //MARK: - didFailToLoadSearchQuery
    
    var didFailToLoadSearchQueryCalled = false
    var didFailToLoadSearchQueryReceivedError: Error?
    
    func didFailToLoadSearchQuery(_ error: Error) {
        didFailToLoadSearchQueryCalled = true
        didFailToLoadSearchQueryReceivedError = error
    }
    
}
