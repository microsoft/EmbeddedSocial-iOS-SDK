//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CommentRepliesViewOutput {
    func viewIsReady()
    func numberOfItems() -> Int
    func postReply(text: String)
    func reply(index: Int) -> Reply
    func loadRestReplies()
    func fetchMore()
    func canFetchMore() -> Bool
    func refresh()
    func mainCommentCell() -> CommentCell
    func loadCellModel() -> LoadMoreCellViewModel
}
