//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockFollowRequestsInteractorOutput: FollowRequestsInteractorOutput {
    
    //MARK: - didUpdateListLoadingState
    
    var didUpdateListLoadingStateCalled = false
    var didUpdateListLoadingStateReceivedIsLoading: Bool?
    
    func didUpdateListLoadingState(_ isLoading: Bool) {
        didUpdateListLoadingStateCalled = true
        didUpdateListLoadingStateReceivedIsLoading = isLoading
    }
    
}
