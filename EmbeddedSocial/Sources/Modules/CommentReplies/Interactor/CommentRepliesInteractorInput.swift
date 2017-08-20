//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CommentRepliesInteractorInput {
    func fetchReplies(commentHandle: String)
    func fetchMoreReplies(commentHandle: String) 
    func postReply(commentHandle: String, text: String)
    func replyAction(replyHandle: String, action: RepliesSocialAction)
}
