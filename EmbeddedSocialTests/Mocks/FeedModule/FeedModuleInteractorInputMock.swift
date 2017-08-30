//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class FeedModuleInteractorInputMock: FeedModuleInteractorInput {
    
    //MARK: - fetchPosts
    
    var fetchPostsCalled = false
    var fetchPostsReceivedArguments: (limit: Int32?, cursor: String?, feedType: FeedType)?
    
    func fetchPosts(limit: Int?, cursor: String?, feedType: FeedType) {
        fetchPostsCalled = true
        fetchPostsReceivedArguments = (limit: limit, cursor: cursor, feedType: feedType)
    }
    
    //MARK: - postAction
    
    var postActionCalled = false
    var postActionReceivedArguments: (post: PostHandle, action: PostSocialAction)?
    
    func postAction(post: PostHandle, action: PostSocialAction) {
        postActionCalled = true
        postActionReceivedArguments = (post: post, action: action)
    }
    
}
