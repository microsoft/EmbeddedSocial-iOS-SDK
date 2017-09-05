//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import Foundation

protocol PostDetailRouterInput {
    func openUser(userHandle: UserHandle, from view: UIViewController)
    func openReplies(commentView: CommentViewModel, scrollType: RepliesScrollType, from view: UIViewController, postDetailPresenter: PostDetailPresenter?)
    func openImage(imageUrl: String, from view: UIViewController)
    func openLogin(from view: UIViewController)
}
