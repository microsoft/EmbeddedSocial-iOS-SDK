//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CommentRepliesViewOutput {
    func viewIsReady()
    func numberOfItems() -> Int
    func mainComment() -> CommentViewModel
    func postReply(text: String)
    func replyView(index: Int) -> ReplyViewModel
    func loadRestReplies()
    func fetchMore()
    func canFetchMore() -> Bool
    func refresh()
}
