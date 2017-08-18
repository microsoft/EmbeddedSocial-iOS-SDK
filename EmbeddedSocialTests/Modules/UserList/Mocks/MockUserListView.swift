//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUserListView: UIView, UserListViewInput {
    private(set) var setupInitialStateCount = 0
    private(set) var setUsersCount = 0
    private(set) var setIsLoadingItemAtCount = 0
    private(set) var isLoadingItemAtParams: (Bool, IndexPath)?
    private(set) var setIsLoadingCount = 0
    private(set) var isLoading: Bool?
    private(set) var users: [User]?
    
    private(set) var updateListItemCount = 0
    private(set) var updateListItemParams: (User, IndexPath)?
    
    private(set) var setListHeaderViewCount = 0
    private(set) var headerView: UIView?
    
    func setupInitialState() {
        setupInitialStateCount += 1
    }
    
    func setUsers(_ users: [User]) {
        setUsersCount += 1
        self.users = users
    }
    
    func updateListItem(with user: User, at indexPath: IndexPath) {
        updateListItemCount += 1
        updateListItemParams = (user, indexPath)
    }
    
    func setIsLoading(_ isLoading: Bool, itemAt indexPath: IndexPath) {
        setIsLoadingItemAtCount += 1
        isLoadingItemAtParams = (isLoading, indexPath)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        setIsLoadingCount += 1
        self.isLoading = isLoading
    }
    
    func setListHeaderView(_ view: UIView?) {
        setListHeaderViewCount += 1
        headerView = view
    }
}
