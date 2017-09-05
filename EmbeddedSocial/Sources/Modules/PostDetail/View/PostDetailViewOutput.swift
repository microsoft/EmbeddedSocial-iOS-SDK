//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostDetailViewOutput {
    func viewIsReady()
    func numberOfItems() -> Int
    func comment(at index: Int) -> Comment
    func postComment(photo: Photo?, comment: String)
    func fetchMore()
    func loadRestComments()
    func enableFetchMore() -> Bool
    func refresh()
    func heightForFeed() -> CGFloat
}
