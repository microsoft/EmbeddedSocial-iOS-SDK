//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import Foundation
@testable import EmbeddedSocial

class MockDetailedActivityPresenter: DetailedActivityInteractorOutput {
    
    var loadedReplyCount = 0
    func loaded(reply: Reply) {
        loadedReplyCount += 1
    }
    
    var loadedCommentCount = 0
    func loaded(comment: Comment) {
        loadedCommentCount += 1
    }
    
    var failedLoadReplyCount = 0
    func failedLoadReply(error: Error) {
        failedLoadReplyCount += 1
    }
    
    var failedLoadCommentCount = 0
    func failedLoadComment(error: Error) {
        failedLoadCommentCount += 1
    }
}
