//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockCommentRepliesRouter: CommentRepliesRouterInput {
    
    func openMyReplyOptions(reply: Reply) {
        
    }
    
    func openOtherReplyOptions(reply: Reply) {
        
    }
    
    
    var backIfNeededCount = 0
    func backIfNeeded(from view: UIViewController) {
        backIfNeededCount += 1
    }
    
    var backCount = 0
    func back() {
        backCount += 1
    }
    
}
