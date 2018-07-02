//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol CommentRepliesRouterInput {
    func backIfNeeded(from view: UIViewController)
    func back()
    func openMyReplyOptions(reply: Reply)
    func openOtherReplyOptions(reply: Reply)
}
