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

extension PostTopicRequest: Cacheable, HandleMixin, RelatedHandleMixin {
    
    func getHandle() -> String? {
        return handle
    }
    
    func getRelatedHandle() -> String? {
        return relatedHandle
    }
    
    func setHandle(_ handle: String?) {
        if let handle = handle {
            self.handle = handle
        }
    }
    
    func setRelatedHandle(_ relatedHandle: String?) {
        if let relatedHandle = relatedHandle {
            self.relatedHandle = relatedHandle
        }
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

extension ReplyView: Cacheable {
    func getHandle() -> String? {
        return replyHandle
    }
    
    func getRelatedHandle() -> String? {
        return commentHandle
    }
}

extension FeedResponseCommentView: Cacheable {
}

extension FeedResponseReplyView: Cacheable {}

extension PostCommentRequest: Cacheable {
    func getHandle() -> String? {
        return UUID().uuidString
    }
}

extension PostReplyRequest: Cacheable {}
