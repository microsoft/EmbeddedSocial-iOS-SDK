//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ActivityTextRender {
    static func render(from item: ActivityItem) -> String? {
        
        switch item  {
        case let .pendingRequest(model):
            return nil
        case let .following(model):
            return OtherActivityTextRender.render(item: model)
        case let .follower(model):
            return MyActivityTextRender.render(item: model)
        }
        
    }
}

class MyActivityTextRender {
    
    private static func renderChild(item: ActivityView) -> String? {
        
        guard
            let content = item.actedOnContent?.text,
            let contentType = item.actedOnContent?.contentType,
            let actor = item.actorUsers?.first?.getFullName()
            else {
                return nil
        }
        
        switch contentType {
        case .comment:
            return L10n.Activity.You.childTopic(actor, content)
        case .reply:
            return L10n.Activity.You.childComment(actor, content)
        default:
            return nil
        }
    }
    
    private static func renderPeer(item: ActivityView) -> String? {
        
        guard
            let content = item.actedOnContent?.text,
            let contentType = item.actedOnContent?.contentType,
            let actor = item.actorUsers?.first?.getFullName()
            else {
                return nil
        }
        
        switch contentType {
        case .comment:
            return L10n.Activity.You.childPeerTopic(actor, content)
        case .reply:
            return L10n.Activity.You.childPeerComment(actor, content)
        default:
            return nil
        }
    }
    
    private static func renderLike(item: ActivityView) -> String? {
        
        guard
            let contentType = item.actedOnContent?.contentType,
            let contentText = item.actedOnContent?.text,
            let actor = item.actorUsers?.first?.getFullName()
            
            else {
                return nil
        }
        
        switch contentType {
        case .comment:
            return L10n.Activity.You.likeComment(actor, contentText)
        case .reply:
            return L10n.Activity.You.likeComment(actor, contentText)
        case .topic:
            return L10n.Activity.You.likeTopic(actor, contentText)
        default:
            return nil
        }
    }
    
    private static func renderFollowing(item: ActivityView) -> String? {
        guard let actor = item.actorUsers?.first?.getFullName() else {
            return nil
        }
        return L10n.Activity.You.following(actor)
    }
    
    static func render(item: ActivityView) -> String? {
        
        guard let activityType = item.activityType else {
            return nil
        }
        
        switch activityType {
        case .following:
            return renderFollowing(item: item)
        case .like:
            return renderLike(item: item)
        case .comment, .reply:
            return renderChild(item: item)
        case .replyPeer, .commentPeer:
            return renderPeer(item: item)
            
        default:
            Logger.log(activityType, "Not supported")
            return nil
        }
    }
    
}

class OtherActivityTextRender {
    static func render(item: ActivityView) -> String {
        return "FIX"
    }
}

