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
        comment.mediaUrl = photo?.url
        comment.mediaHandle = photo?.uid
        output.commentDidPost(comment: comment)
    }
    
}
