//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CommentCellRouterInput {
    func openReplies(scrollType: RepliesScrollType, commentModulePresenter: CommentCellModuleProtocol)
    func openUser(userHandle: String)
    func openImage(imageUrl: String)
    func openLikes(commentHandle: String)
    func openMyCommentOptions(comment: Comment)
    func openOtherCommentOptions(comment: Comment)
    func openMyProfile()
}
