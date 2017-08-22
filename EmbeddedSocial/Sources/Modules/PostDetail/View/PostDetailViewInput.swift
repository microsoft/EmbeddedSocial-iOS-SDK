//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostDetailViewInput: class {

    /**
        @author generamba setup
        Setup initial state of the view
    */

    func setupInitialState()
    func updateFeed(view: UIView, scrollType: CommentsScrollType)
    func reloadTable(scrollType: CommentsScrollType)
    func postCommentSuccess()
    func postCommentFailed(error: Error)
    func refreshCell(index: Int)
}
