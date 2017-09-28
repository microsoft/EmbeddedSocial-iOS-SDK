//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension Photo: Cacheable {
    func encodeToJSON() -> Any {
        return self.memento
    }
    
    func getHandle() -> String? {
        return uid
    }
}

extension UserProfileView: Cacheable {
    func getHandle() -> String? {
        return userHandle
    }
}

extension CommentView: Cacheable {
    func getHandle() -> String? {
        return commentHandle
    }
    
    func getRelatedHandle() -> String? {
        return topicHandle
    }
}

extension UserCompactView: Cacheable {
    func getHandle() -> String? {
        return userHandle
    }
    
    func setHandle(_ handle: String?) {
        userHandle = handle
    }
}

extension ReplyView: Cacheable {
    func getHandle() -> String? {
        return replyHandle
    }
    
    func getRelatedHandle() -> String? {
        return commentHandle
    }
}

extension PostTopicRequest: Cacheable, HandleMixin, RelatedHandleMixin { }

extension PostCommentRequest: Cacheable, HandleMixin, RelatedHandleMixin { }

extension PostReplyRequest: Cacheable, HandleMixin, RelatedHandleMixin { }

extension FeedResponseTopicView: Cacheable, HandleMixin { }

extension FeedResponseUserCompactView: Cacheable, HandleMixin {  }

extension FeedResponseActivityView: Cacheable, HandleMixin { }

extension FeedResponseCommentView: Cacheable, HandleMixin { }

extension FeedResponseReplyView: Cacheable, HandleMixin { }

extension TopicView: Cacheable, HandleMixin { }

