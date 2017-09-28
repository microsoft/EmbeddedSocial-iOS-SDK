//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockFollowRequestsView: FollowRequestsViewInput {
    
    //MARK: - setupInitialState
    
    var setupInitialStateCalled = false
    
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
    //MARK: - setUsers
    
    var setUsersCalled = false
    var setUsersReceivedUsers: [User]?
    
    func setUsers(_ users: [User]) {
        setUsersCalled = true
        setUsersReceivedUsers = users
    }
    
    //MARK: - setIsLoading
    
    var setIsLoadingItemCalled = false
    var setIsLoadingItemReceivedArguments: (isLoading: Bool, item: FollowRequestItem)?
    
    func setIsLoading(_ isLoading: Bool, item: FollowRequestItem) {
        setIsLoadingItemCalled = true
        setIsLoadingItemReceivedArguments = (isLoading: isLoading, item: item)
    }
    
    //MARK: - setIsLoading
    
    var setIsLoadingCalled = false
    var setIsLoadingReceivedIsLoading: Bool?
    
    func setIsLoading(_ isLoading: Bool) {
        setIsLoadingCalled = true
        setIsLoadingReceivedIsLoading = isLoading
    }
    
    //MARK: - removeUser
    
    var removeUserCalled = false
    var removeUserReceivedUser: User?
    
    func removeUser(_ user: User) {
        removeUserCalled = true
        removeUserReceivedUser = user
    }
    
    //MARK: - endPullToRefreshAnimation
    
    var endPullToRefreshAnimationCalled = false
    
    func endPullToRefreshAnimation() {
        endPullToRefreshAnimationCalled = true
    }
    
    //MARK: - setIsEmpty
    
    var setIsEmptyCalled = false
    var setIsEmptyReceivedIsEmpty: Bool?
    
    func setIsEmpty(_ isEmpty: Bool) {
        setIsEmptyCalled = true
        setIsEmptyReceivedIsEmpty = isEmpty
    }
    
    //MARK: - showError
    
    var showErrorCalled = false
    var showErrorReceivedError: Error?
    
    func showError(_ error: Error) {
        showErrorCalled = true
        showErrorReceivedError = error
    }
    
    //MARK: - setNoDataText
    
    var setNoDataTextCalled = false
    var setNoDataTextReceivedText: NSAttributedString?
    
    func setNoDataText(_ text: NSAttributedString?) {
        setNoDataTextCalled = true
        setNoDataTextReceivedText = text
    }
    
}
