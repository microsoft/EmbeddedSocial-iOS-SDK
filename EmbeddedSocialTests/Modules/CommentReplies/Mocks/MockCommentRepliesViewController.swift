//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentRepliesViewController: UIViewController, CommentRepliesViewInput {
    
    var output: CommentRepliesViewOutput!
    
    var setupCount = 0
    func setupInitialState() {
        setupCount += 1
    }
    
    var refreshCommentCellCount = 0
    func refreshCommentCell() {
        refreshCommentCellCount += 1
    }
    
    var refreshReplyCellCount = 0
    func refreshReplyCell(index: Int) {
        refreshReplyCellCount += 1
    }
    
    var replyPostedCount = 0
    func replyPosted() {
        replyPostedCount += 1
    }
    
    var reloadRepliesCount = 0
    func reloadReplies() {
        reloadRepliesCount += 1
    }
    
    var reloadTableCount = 0
    func reloadTable(scrollType: RepliesScrollType) {
        reloadTableCount += 1
    }
    
    var lockUICount = 0
    func lockUI() {
        lockUICount += 1
    }
    
    var updateLoadingCellCount = 0
    func updateLoadingCell() {
        
    }
}
