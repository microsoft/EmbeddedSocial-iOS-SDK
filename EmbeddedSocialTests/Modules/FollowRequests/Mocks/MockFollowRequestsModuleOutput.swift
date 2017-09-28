//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockFollowRequestsModuleOutput: FollowRequestsModuleOutput {
    
    //MARK: - didAcceptFollowRequest
    
    var didAcceptFollowRequestCalled = false
    
    func didAcceptFollowRequest() {
        didAcceptFollowRequestCalled = true
    }
    
}
