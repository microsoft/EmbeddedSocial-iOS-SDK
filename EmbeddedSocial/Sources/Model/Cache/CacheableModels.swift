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

extension PostCommentRequest: Cacheable, HandleMixin, RelatedHandleMixin {
    
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

extension PostReplyRequest: Cacheable, HandleMixin, RelatedHandleMixin {
    
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

extension FeedResponseTopicView: Cacheable { }

extension FeedResponseUserCompactView: Cacheable, HandleMixin {
    func getHandle() -> String? {
        return handle
    }
    
    func setHandle(_ handle: String?) {
        if let handle = handle {
            self.handle = handle
        }
    }
}

extension FeedResponseActivityView: Cacheable, HandleMixin {
    func getHandle() -> String? {
        return handle
    }
    
    func setHandle(_ handle: String?) {
        if let handle = handle {
            self.handle = handle
        }
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

class LikeCommentRequest: Cacheable, HandleMixin{
    var commentHandle: String
    
    init(commentHandle: String) {
        self.commentHandle = commentHandle
    }
    
    func setHandle(_ handle: String?) {
        if let handle = handle {
            self.handle = handle
        }
    }
    
    func getHandle() -> String? {
        return commentHandle
    }
    
    func encodeToJSON() -> Any {
        return ["commentHandle" : commentHandle]
    }
}

extension FeedResponseCommentView: Cacheable, HandleMixin {
    func setHandle(_ handle: String?) {
        if let handle = handle {
            self.handle = handle
        }
    }
    
    func getHandle() -> String? {
        return handle
    }
}

extension FeedResponseReplyView: Cacheable, HandleMixin {
    func setHandle(_ handle: String?) {
        if let handle = handle {
            self.handle = handle
        }
    }
    
    func getHandle() -> String? {
        return handle
    }
}

