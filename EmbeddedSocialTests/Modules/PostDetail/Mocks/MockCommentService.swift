//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentService: CommentsService {
    override func fetchComments(topicHandle: String, cursor: String?, limit: Int32?, resultHandler: @escaping CommentFetchResultHandler) {
        resultHandler(CommentFetchResult(comments: [Comment()], error: nil, cursor: nil))
    }
}
