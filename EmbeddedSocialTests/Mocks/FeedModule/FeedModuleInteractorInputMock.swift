//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class FeedModuleInteractorInputMock: FeedModuleInteractorInput {
    
    //MARK: - fetchPosts
    
    var fetchPostsRequestCalled = false
    var fetchPostsRequestReceivedRequest: FeedFetchRequest?
    
    func fetchPosts(request: FeedFetchRequest) {
        fetchPostsRequestCalled = true
        fetchPostsRequestReceivedRequest = request
    }
    
    //MARK: - postAction
    
    var postActionPostActionCalled = false
    var postActionPostActionReceivedArguments: (post: PostHandle, action: PostSocialAction)?
    
    func postAction(post: Post, action: PostSocialAction) {
        postActionPostActionCalled = true
        postActionPostActionReceivedArguments = (post: post.topicHandle, action: action)
    }
}
