//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
@testable import EmbeddedSocial

class MockTrendingTopicsViewController: UIViewController, TrendingTopicsViewInput {
    
    //MARK: - setupInitialState
    
    var setupInitialStateCalled = false
    
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
    //MARK: - setHashtags
    
    var setHashtagsCalled = false
    var setHashtagsReceivedHashtags: [Hashtag]?
    
    func setHashtags(_ hashtags: [Hashtag]) {
        setHashtagsCalled = true
        setHashtagsReceivedHashtags = hashtags
    }
    
    //MARK: - showError
    
    var showErrorCalled = false
    var showErrorReceivedError: Error?
    
    func showError(_ error: Error) {
        showErrorCalled = true
        showErrorReceivedError = error
    }
    
    //MARK: - setIsLoading
    
    var setIsLoadingCalled = false
    var setIsLoadingReceivedIsLoading: Bool?
    
    func setIsLoading(_ isLoading: Bool) {
        setIsLoadingCalled = true
        setIsLoadingReceivedIsLoading = isLoading
    }
    
    //MARK: - endPullToRefreshAnimation
    
    var endPullToRefreshAnimationCalled = false
    
    func endPullToRefreshAnimation() {
        endPullToRefreshAnimationCalled = true
    }
    
}
