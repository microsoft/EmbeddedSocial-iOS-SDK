//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CommentRepliesRouterInput {
    func openUser(userHandle: UserHandle, from view: UIViewController)
    func openLikes(replyHandle: String, from view: UIViewController)
    func openMyReplyOptions(reply: Reply, from view: UIViewController)
    func openOtherReplyOptions(reply: Reply, from view: UIViewController)
    func openLogin(from viewController: UIViewController)
}
