//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostDetailViewOutput {

    /**
        @author generamba setup
        Notify presenter that view is ready
    */

    func viewIsReady()
    func numberOfItems() -> Int
    var post: Post? {get set}
    func comment(index: Int) -> Comment
    func postComment(photo: Photo?, comment: String)
    func likeComment(comment: Comment)
    func unlikeComment(comment: Comment)
    func fetchMore()
    func openUser(index: Int)
    func feedModuleHeight() -> CGFloat
}
