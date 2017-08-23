//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockPostDetailViewController: PostDetailViewInput {
    
    var output: PostDetailViewOutput!
    
    var setupCount = 0
    func setupInitialState() {
        setupCount += 1
    }
    
    var tableRelaodedCount = 0
    func reloadTable(scrollType: CommentsScrollType) {
        tableRelaodedCount += 1
    }
    
    var updatedFeedCount = 0
    func updateFeed(view: UIView, scrollType: CommentsScrollType) {
        updatedFeedCount += 1
    }
    
    var commentPostedCount = 0
    func postCommentSuccess() {
        commentPostedCount += 1
    }
    
    var commentPostFailed = 0
    func postCommentFailed(error: Error) {
        commentPostedCount += 1
    }
    
    var commentsLike = ""
    func refreshCell(index: Int) {
        let comment = output.commentViewModel(index: index)
        commentsLike = comment.totalLikes
    }
    
    func refreshPostCell() {
        
    }
}
