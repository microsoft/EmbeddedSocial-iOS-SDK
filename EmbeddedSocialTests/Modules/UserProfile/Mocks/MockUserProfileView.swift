//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserProfileView: UserProfileViewInput {
    private(set) var setupInitialStateCount = 0
    private(set) var showErrorCount = 0
    private(set) var lastShownError: Error?
    private(set) var isLoadingUser: Bool?
    private(set) var setUserCount = 0
    private(set) var lastSetUser: User?
    private(set) var setFollowStatusCount = 0
    private(set) var lastFollowStatus: FollowStatus?
    private(set) var setIsProcessingFollowRequestCount = 0
    private(set) var isProcessingFollowRequest: Bool?
    private(set) var lastFollowersCount: Int?
    private(set) var setFollowersCount = 0
    private(set) var setFeedViewControllerCount = 0
    private(set) var setFollowingCount = 0
    private(set) var lastFollowingCount: Int?
    private(set) var setStickyFilterHiddenCount = 0
    private(set) var isStickyFilterHidden: Bool?
    private(set) var setupHeaderViewCount = 0
    private(set) var setFilterEnabledCount = 0
    private(set) var isFilterEnabled: Bool?
    private(set) var setLayoutAssetCount = 0
    private(set) var layoutAsset: Asset?
    
    var headerContentHeight: CGFloat = 0.0

    func setupInitialState(showGalleryView: Bool) {
        setupInitialStateCount += 1
    }
    
    func showError(_ error: Error) {
        showErrorCount += 1
        lastShownError = error
    }
    
    func setIsLoadingUser(_ isLoading: Bool) {
        self.isLoadingUser = isLoading
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
    
    func setFeedViewController(_ feedViewController: UIViewController) {
        setFeedViewControllerCount += 1
    }
    
    func setFollowingCount(_ followingCount: Int) {
        lastFollowingCount = followingCount
        setFollowingCount += 1
    }
    
    func setStickyFilterHidden(_ isHidden: Bool) {
        isStickyFilterHidden = isHidden
        setStickyFilterHiddenCount += 1
    }
    
    func setupHeaderView(_ reusableView: UICollectionReusableView) {
        setupHeaderViewCount += 1
    }
    
    func setFilterEnabled(_ isEnabled: Bool) {
        setFilterEnabledCount += 1
        isFilterEnabled = isEnabled
    }
    
    func setLayoutAsset(_ asset: Asset) {
        layoutAsset = asset
        setLayoutAssetCount += 1
    }
    
    
    var setupPrivateAppearanceCalled = false
    func setupPrivateAppearance() {
        setupPrivateAppearanceCalled = true
    }
}
