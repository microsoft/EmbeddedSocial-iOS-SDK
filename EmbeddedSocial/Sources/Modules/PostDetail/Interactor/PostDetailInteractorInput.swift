//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PostDetailInteractorInput {
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32)
    func fetchMoreComments(topicHandle: String, cursor: String?, limit: Int32)
    func postComment(photo: Photo?, topicHandle: String, comment: String)
    func commentAction(commentHandle: String, action: CommentSocialAction)
    func loadPost(topicHandle: String)
}
