//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol PostDetailViewInput: class {
    func setupInitialState()
    func reloadTable(scrollType: CommentsScrollType)
    func postCommentSuccess()
    func postCommentFailed(error: Error)
    func refreshCell(index: Int)
    func refreshPostCell()
    func setFeedViewController(_ feedViewController: UIViewController)
    func updateComments()
    func showLoadingHUD()
    func hideLoadingHUD()
    func updateLoadingCell()
    func removeComment(index: Int)
    func scrollCollectionViewToBottom()
    func endRefreshing()
}
