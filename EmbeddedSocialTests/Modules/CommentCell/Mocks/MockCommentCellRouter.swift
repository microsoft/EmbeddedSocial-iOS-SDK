//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentCellRouter: CommentCellRouterInput {
    
    var openImageCount = 0
    func openImage(imageUrl: String) {
        openImageCount += 1
    }
    
    var openUserCount = 0
    func openUser(userHandle: String) {
        openUserCount += 1
    }
    
    var openRepliesCount = 0
    func openReplies(scrollType: RepliesScrollType, commentModulePresenter: CommentCellModuleProtocol) {
        openRepliesCount += 1
    }
    
    var openLikesCount = 0
    func openLikes(commentHandle: String) {
        openLikesCount = 1
    }
    
    var openLoginCount = 0
    func openLogin() {
        openLoginCount += 1
    }
    
    var openMyCommentOptionsCount = 0
    func openMyCommentOptions(comment: Comment) {
        openMyCommentOptionsCount += 1
    }
    
    var openOtherCommentOptionsCount = 0
    func openOtherCommentOptions(comment: Comment) {
        openOtherCommentOptionsCount += 1
    }
}
