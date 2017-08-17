//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockPostDetailViewController: PostDetailViewInput {
    
    var output: PostDetailViewOutput!
    
    func setupInitialState() {
        
    }
    
    func reloadTable() {
        
    }
    
    func updateFeed(view: UIView) {
        
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
    
}
