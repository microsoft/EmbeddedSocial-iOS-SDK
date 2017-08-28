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

extension PostTopicRequest: Cacheable { }

extension CommentView: Cacheable {
    func getHandle() -> String? {
        return commentHandle
    }
    
    func getRelatedHandle() -> String? {
        return topicHandle
    }
}

extension FeedResponseTopicView: Cacheable {
    
}
