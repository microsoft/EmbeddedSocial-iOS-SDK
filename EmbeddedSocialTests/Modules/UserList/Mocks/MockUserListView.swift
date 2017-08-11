//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUserListView: UIView, UserListViewInput {
    var setupInitialStateCount = 0
    var setUsersCount = 0
    var setIsLoadingItemAtCount = 0
    var isLoadingItemAtParams: (Bool, IndexPath)?
    var setIsLoadingCount = 0
    var isLoading: Bool?
    var users: [User]?
    
    var updateListItemCount = 0
    var updateListItemParams: (User, IndexPath)?
    
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
}
