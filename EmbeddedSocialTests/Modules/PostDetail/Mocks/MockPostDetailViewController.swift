//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockPostDetailViewController: UIViewController, PostDetailViewInput {
    
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
//        let comment = output.commentViewModel(index: index)
//        commentsLike = comment.totalLikes
    }
    
    var postCellRefreshCount = 0
    func refreshPostCell() {
        postCellRefreshCount = 1
    }
    
    var updateCommentsCount = 0
    func updateComments() {
        updateCommentsCount += 1
    }
    
    var updateLoadingCellCount = 0
    func updateLoadingCell() {
        updateLoadingCellCount += 1
    }
    
    func setFeedViewController(_ feedViewController: UIViewController) {
        
    }
    
    var removeCommentCount = 0
    func removeComment(index: Int) {
        removeCommentCount += 1
    }
    
    var scrollCollectionViewToBottomCount = 0
    func scrollCollectionViewToBottom() {
        scrollCollectionViewToBottomCount += 1
    }
    
    var endRefreshingCount = 0
    func endRefreshing() {
        endRefreshingCount += 1
    }
    
    func showLoadingHUD() {
        
    }
    
    func hideLoadingHUD() {
        
    }
}
