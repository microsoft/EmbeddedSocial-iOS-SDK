//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUserListView: UIView, UserListViewInput {
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
    
    //MARK: - updateListItem
    
    var updateListItemWithCalled = false
    var updateListItemWithReceivedUser: User?
    
    func updateListItem(with user: User) {
        updateListItemWithCalled = true
        updateListItemWithReceivedUser = user
    }
    
    //MARK: - setIsLoading
    
    var setIsLoadingItemCalled = false
    var setIsLoadingItemReceivedArguments: (isLoading: Bool, item: UserListItem)?
    
    func setIsLoading(_ isLoading: Bool, item: UserListItem) {
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
    
    //MARK: - setListHeaderView
    
    var setListHeaderViewCalled = false
    var setListHeaderViewReceivedView: UIView?
    
    func setListHeaderView(_ view: UIView?) {
        setListHeaderViewCalled = true
        setListHeaderViewReceivedView = view
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
    
    //MARK: - setNoDataText
    
    var setNoDataTextCalled = false
    var setNoDataTextReceivedText: NSAttributedString?
    
    func setNoDataText(_ text: NSAttributedString?) {
        setNoDataTextCalled = true
        setNoDataTextReceivedText = text
    }
    
    //MARK: - setNoDataView
    
    var setNoDataViewCalled = false
    var setNoDataViewReceivedView: UIView?
    
    func setNoDataView(_ view: UIView?) {
        setNoDataViewCalled = true
        setNoDataViewReceivedView = view
    }
    
    //MARK: - setIsEmpty
    
    var setIsEmptyCalled = false
    var setIsEmptyReceivedIsEmpty: Bool?
    
    func setIsEmpty(_ isEmpty: Bool) {
        setIsEmptyCalled = true
        setIsEmptyReceivedIsEmpty = isEmpty
    }
}
