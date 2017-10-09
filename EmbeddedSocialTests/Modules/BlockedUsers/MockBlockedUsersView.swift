//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockBlockedUsersView: BlockedUsersViewInput {
    
    //MARK: - setupInitialState
    
    var setupInitialState_userListView_Called = false
    var setupInitialState_userListView_ReceivedUserListView: UIView?
    
    func setupInitialState(userListView: UIView) {
        setupInitialState_userListView_Called = true
        setupInitialState_userListView_ReceivedUserListView = userListView
    }
    
    //MARK: - showError
    
    var showError___Called = false
    var showError___ReceivedError: Error?
    
    func showError(_ error: Error) {
        showError___Called = true
        showError___ReceivedError = error
    }
    
}
