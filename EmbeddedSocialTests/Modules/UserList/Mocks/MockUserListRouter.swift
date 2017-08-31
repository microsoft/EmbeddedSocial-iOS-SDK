//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUserListRouter: UserListRouterInput {
    
    private(set) var openUserProfileCount = 0
    var openUserProfileUserID: String?
    
    func openUserProfile(_ userID: String) {
        openUserProfileCount += 1
        openUserProfileUserID = userID
    }
    
    private(set) var openMyProfileCount = 0
    
    func openMyProfile() {
        openMyProfileCount += 1
    }
}

