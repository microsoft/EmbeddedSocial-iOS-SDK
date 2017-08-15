//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockPostDetailViewController: PostDetailViewController {
    
    var commentPostedCount = 0
    override func postCommentSuccess() {
        commentPostedCount += 1
    }
    
    var commentsLike = 0
    override func refreshCell(index: Int) {
        let comment = output.comment(index: index)
        commentsLike = Int(comment.totalLikes)
    }
    
}
