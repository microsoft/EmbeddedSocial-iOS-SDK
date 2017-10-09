//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentCellPresenter: CommentCellPresenter {
    
    override func didPostAction(action: CommentSocialAction, error: Error?) {
        switch action {
        case .like:
            comment.totalLikes += 1
            comment.liked = true
        case .unlike:
            comment.totalLikes -= 1
            comment.liked = false
        }
    }
}
