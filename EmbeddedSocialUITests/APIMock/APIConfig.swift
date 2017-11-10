//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct APIConfig {
    public static var delayedResponses: Bool {
        return responsesDelay != 0
    }
    
    // Delay for responses (in seconds)
    public static var responsesDelay: TimeInterval = 0
    
    public static var showTopicImages = false
    public static var showUserImages = false
    public static var numberedTopicTeasers = false
    public static var showCommentHandleInTeaser = false
    public static var numberedCommentLikes = false
    public static var loadMyTopics = false
    public static var isReachable = true
    public static var wrongResponses = false
    public static var wrongFeedFetching = false
    public static var values = [:] as [String: Any]
}
