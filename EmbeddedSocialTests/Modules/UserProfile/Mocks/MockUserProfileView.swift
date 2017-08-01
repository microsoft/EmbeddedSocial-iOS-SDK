//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserProfileView: UserProfileViewInput {
    private(set) var setupInitialStateCount = 0
    private(set) var showErrorCount = 0
    private(set) var lastShownError: Error?
    private(set) var isLoading: Bool?
    private(set) var setUserCount = 0
    private(set) var lastSetUser: User?
    private(set) var setFollowStatusCount = 0
    private(set) var lastFollowStatus: FollowStatus?
    private(set) var setIsProcessingFollowRequestCount = 0
    private(set) var isProcessingFollowRequest: Bool?
    private(set) var lastFollowersCount: Int?
    private(set) var setFollowersCount = 0

    func setupInitialState() {
        setupInitialStateCount += 1
    }
    
    func showError(_ error: Error) {
        showErrorCount += 1
        lastShownError = error
    }
    
    func setIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func setUser(_ user: User) {
        setUserCount += 1
        lastSetUser = user
    }
    
    func setFollowStatus(_ followStatus: FollowStatus) {
        setFollowStatusCount += 1
        lastFollowStatus = followStatus
    }
    
    func setIsProcessingFollowRequest(_ isLoading: Bool) {
        isProcessingFollowRequest = isLoading
    }
    
    func setFollowersCount(_ followersCount: Int) {
        lastFollowersCount = followersCount
        setFollowersCount += 1
    }
}
