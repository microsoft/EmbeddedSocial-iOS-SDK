//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CommentRepliesViewInput: class {
    func setupInitialState()
    func reloadTable(scrollType: RepliesScrollType)
    func reloadReplies()
    func refreshReplyCell(index: Int)
    func refreshCommentCell()
    func replyPosted()
    func lockUI()
    func updateLoadingCell()
}
