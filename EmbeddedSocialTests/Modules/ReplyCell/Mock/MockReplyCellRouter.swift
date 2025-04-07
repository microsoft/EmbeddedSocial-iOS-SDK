//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockReplyCellRouter: ReplyCellRouterInput {
    
    func openMyProfile() {
        
    }
    
    var openUserCount = 0
    func openUser(userHandle: String) {
        openUserCount += 1
    }
    
    var openLoginCount = 0
    func openLogin() {
        openLoginCount += 1
    }
    
    var openLikesCount = 0
    func openLikes(replyHandle: String) {
        openLikesCount += 1
    }
    
    var openMyReplyOptionsCount = 0
    func openMyReplyOptions(reply: Reply) {
        openMyReplyOptionsCount += 1
    }
    
    var openOtherReplyOptionsCount = 0
    func openOtherReplyOptions(reply: Reply) {
        openOtherReplyOptionsCount += 1
    }
}
