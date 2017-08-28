//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserProfileViewInput: class {
    func setupInitialState()
    
    func setFeedViewController(_ feedViewController: UIViewController)
    
    func showError(_ error: Error)
    
    func setIsLoadingUser(_ isLoading: Bool)
    
    func setUser(_ user: User, isAnonymous: Bool)
    
    func setFollowStatus(_ followStatus: FollowStatus)
    
    func setIsProcessingFollowRequest(_ isLoading: Bool)
        
    func setFollowersCount(_ followersCount: Int)
    
    func setFollowingCount(_ followingCount: Int)

    func setupHeaderView(_ reusableView: UICollectionReusableView)
    
    func setStickyFilterHidden(_ isHidden: Bool)
    
    func setFilterEnabled(_ isEnabled: Bool)
    
    func setLayoutAsset(_ asset: Asset)
}
