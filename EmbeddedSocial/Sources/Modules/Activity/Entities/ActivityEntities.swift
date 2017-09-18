//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct Activity {
    
    struct ActionItem {
        
        var unread: Bool
        
        enum ActivityType: String {
            case like = "Like"
            case comment = "Comment"
            case reply = "Reply"
            case commentPeer = "CommentPeer"
            case replyPeer = "ReplyPeer"
            case following = "Following"
            case followRequest = "FollowRequest"
            case followAccept = "FollowAccept"
        }
        
        var type: ActivityType
        
        var actorNameList: [(firstName: String, lastName: String)] = []
        var actedOnName: String
    }
    
    struct PendingRequestItem {
        var userName: String
        var userHandle: String
    }

    enum ItemType {
        case myActivity
        case othersActivity
        case myPendings
    }
    
    enum Errors: Error {
        case notParsable
        case noData
        case mapperNotFound
        case loaderNotFound
    }
}
