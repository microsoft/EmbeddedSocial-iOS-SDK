//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockSearchTopicsModuleOutput: SearchTopicsModuleOutput {
    
    //MARK: - didFailToLoadSearchQuery
    
    var didFailToLoadSearchQueryCalled = false
    var didFailToLoadSearchQueryReceivedError: Error?
    
    func didFailToLoadSearchQuery(_ error: Error) {
        didFailToLoadSearchQueryCalled = true
        didFailToLoadSearchQueryReceivedError = error
    }
    
}
