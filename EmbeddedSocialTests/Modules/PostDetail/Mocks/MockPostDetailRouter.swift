//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockPostDetailRouter: PostDetailRouterInput {
    
    var openImageCount = 0
    func openImage(imageUrl: String, from view: UIViewController) {
       openImageCount += 1
    }
    
    var openUserCount = 0
    func openUser(userHandle: UserHandle, from view: UIViewController) {
        openUserCount += 1
    }
    
    var openRepliesCount = 0
    func openReplies(commentView: CommentViewModel, scrollType: RepliesScrollType, from view: UIViewController, postDetailPresenter: PostDetailPresenter?) {
        openRepliesCount += 1
    }
}
