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
    
    override func apply(to feed: inout CommentFetchResult) {
        var comments = feed.comments
        comments.insert(comment, at: 0)
        feed.comments = comments
    }
}


extension CreateCommentCommand: TopicsFeedApplicableCommand {
    
    func apply(to feed: inout FeedFetchResult) {
        guard let index = feed.posts.index(where: { $0.topicHandle == self.comment.topicHandle }) else {
            return
        }
        var topic = feed.posts[index]
        topic.totalComments += 1
        feed.posts[index] = topic
    }
}

extension CreateCommentCommand: SingleTopicApplicableCommand {
    func apply(to topic: inout Post) {
        topic.totalComments += 1
    }
}
