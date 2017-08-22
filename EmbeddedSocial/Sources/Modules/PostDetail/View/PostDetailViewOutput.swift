//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostDetailViewOutput {

    func viewIsReady()
    func numberOfItems() -> Int
    var post: PostViewModel? {get set}
    func commentViewModel(index: Int) -> CommentViewModel
    func postComment(photo: Photo?, comment: String)
    func fetchMore()
    func openUser(index: Int)
    func openReplies(index: Int)
    func loadRestComments()
    func refresh()
}
