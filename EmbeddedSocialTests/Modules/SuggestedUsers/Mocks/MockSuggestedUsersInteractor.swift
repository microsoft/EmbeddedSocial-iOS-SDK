//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockSuggestedUsersInteractor: SuggestedUsersInteractorInput {
    var isFriendsListPermissionGranted = false
    
    //MARK: - requestFriendsListPermission
    
    var requestFriendsListPermissionCalled = false
    var requestFriendsListPermissionResult: Result<CredentialsList>!
    var requestFriendsListPermissionReceivedParentViewController: UIViewController?
    
    func requestFriendsListPermission(parentViewController vc: UIViewController?,
                                      completion: @escaping (Result<CredentialsList>) -> Void) {
        requestFriendsListPermissionCalled = true
        requestFriendsListPermissionReceivedParentViewController = vc
        completion(requestFriendsListPermissionResult)
    }
    
}
