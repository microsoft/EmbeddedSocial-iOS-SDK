//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockPostDetailPresenter: PostDetailPresenter {
    
    var fetchedMoreCommentsCount = 0
    override func didFetchMore(comments: [Comment], cursor: String?) {
        fetchedMoreCommentsCount = comments.count
    }
    
    var fetchedCommentsCount = 0
    override func didFetch(comments: [Comment], cursor: String?) {
        fetchedCommentsCount = comments.count
    }

    var postedComment: Comment?
    override func commentDidPosted(comment: Comment) {
        postedComment = comment
    }
}
