//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserProfileModuleOutput: UserProfileModuleOutput {
    
    //MARK: - didChangeUserFollowStatus
    
    var didChangeUserFollowStatusCalled = false
    var didChangeUserFollowStatusReceivedUser: User?
    
    func didChangeUserFollowStatus(_ user: User) {
        didChangeUserFollowStatusCalled = true
        didChangeUserFollowStatusReceivedUser = user
    }
    
}
