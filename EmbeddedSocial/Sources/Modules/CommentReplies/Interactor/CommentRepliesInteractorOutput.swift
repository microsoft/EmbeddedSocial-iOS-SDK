//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CommentRepliesInteractorOutput: class {
    func fetched(replies: [Reply])
    func fetchedMore(replies: [Reply])
    func replyPosted(reply: Reply)
    func replyFailPost(error: Error)
    func didPostAction(replyHandle: String, action: RepliesSocialAction, error: Error?)
}
