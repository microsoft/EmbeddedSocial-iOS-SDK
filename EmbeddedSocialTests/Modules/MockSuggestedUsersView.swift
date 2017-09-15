//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockSuggestedUsersView: SuggestedUsersViewInput {
    
    //MARK: - setupInitialState
    
    var setupInitialStateUserListViewCalled = false
    var setupInitialStateUserListViewReceivedUserListView: UIView?
    
    func setupInitialState(userListView: UIView) {
        setupInitialStateUserListViewCalled = true
        setupInitialStateUserListViewReceivedUserListView = userListView
    }
    
    //MARK: - showError
    
    var showErrorCalled = false
    var showErrorReceivedError: Error?
    
    func showError(_ error: Error) {
        showErrorCalled = true
        showErrorReceivedError = error
    }
    
}
