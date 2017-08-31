//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockPostDetailsInteractor: PostDetailInteractorInput {
    
    weak var output: PostDetailInteractorOutput!
    
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32) {
        output.didFetchMore(comments: [Comment()], cursor: cursor)
    }
    
    func fetchMoreComments(topicHandle: String, cursor: String?, limit: Int32) {
        output.didFetchMore(comments: [Comment()], cursor: cursor)
    }
    
    func postComment(photo: Photo?, topicHandle: String, comment: String) {
        let comment = Comment()
        comment.photoUrl = photo?.url
        output.commentDidPost(comment: comment)
    }
    
    func commentAction(commentHandle: String, action: CommentSocialAction) {
        output.didPostAction(commentHandle: commentHandle, action: action, error: nil)
    }
    
    var loadPostCount = 0
    func loadPost(topicHandle: String) {
        loadPostCount += 1
        let post = Post(topicHandle: "handle", createdTime: Date(), userHandle: "user", userStatus: .none, firstName: "first", lastName: "last", photoHandle: "photoHandle", photoUrl: "photoUrl", title: "title", text: "text", imageUrl: "imageUrl", deepLink: nil, totalLikes: 0, totalComments: 0, liked: false, pinned: false)
        output.postFetched(post:post)
    }
}
