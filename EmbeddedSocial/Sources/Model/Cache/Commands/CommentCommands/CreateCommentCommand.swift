//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateCommentCommand: CommentCommand {
    override func setRelatedHandle(_ relatedHandle: String?) {
        comment.topicHandle = relatedHandle
    }
    
    override func getRelatedHandle() -> String? {
        return comment.topicHandle
    }
}
