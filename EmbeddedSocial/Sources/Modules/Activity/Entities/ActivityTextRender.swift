//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ActivityTextRender {
    static let shared = ActivityTextRender()
    
    let othersActivityTextRender = OthersActivityTextRender()
    let myActivityTextRender = MyActivityTextRender()
    
    func render(item: ActivityItem) -> String? {
        
        switch item  {
        case .pendingRequest(_ ):
            return nil
        case let .othersActivity(model):
            return othersActivityTextRender.render(item: model)
        case let .myActivity(model):
            return myActivityTextRender.render(item: model)
        }
    }
    
    func renderOthersActivity(model: ActivityView) -> String? {
        return othersActivityTextRender.render(item: model)
    }
    
    func renderMyActivity(model: ActivityView) -> String? {
        return myActivityTextRender.render(item: model)
    }
    
}

class BaseActivityTextRender {
    
    func render(item: ActivityView) -> String? {
        
        guard let activityType = item.activityType else {
            Logger.log("Failed parsing", item, event: .veryImportant)
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
        case .followAccept:
            return renderFollowAccepted(item: item)
        default:
            Logger.log(activityType, "Not supported")
            return nil
        }
    }
    
    func renderChild(item: ActivityView) -> String? { return "No impl" }
    func renderPeer(item: ActivityView) -> String? { return "No impl" }
    func renderLike(item: ActivityView) -> String? { return "No impl" }
    func renderFollowing(item: ActivityView) -> String? { return "No impl" }
    func renderFollowAccepted(item: ActivityView) -> String? { return "No impl" }
}

class MyActivityTextRender: BaseActivityTextRender {
    
    override func renderChild(item: ActivityView) -> String? {
        
        guard
            let content = item.actedOnContent?.text,
            let contentType = item.actedOnContent?.contentType,
            let actor = item.actorUsers?.first?.getFullName()
            else {
                Logger.log("Failed parsing", item, event: .veryImportant)
                return nil
        }
        
        switch contentType {
        case .topic:
            return L10n.Activity.You.childTopic(actor, content)
        case .comment:
            return L10n.Activity.You.childComment(actor, content)
        default:
            Logger.log("Failed parsing", contentType , event: .veryImportant)
            return nil
        }
    }
    
    override func renderPeer(item: ActivityView) -> String? {
        
        guard
            let content = item.actedOnContent?.text,
            let contentType = item.actedOnContent?.contentType,
            let actor = item.actorUsers?.first?.getFullName()
            else {
                Logger.log(item, "Failed parsing", event: .veryImportant)
                return nil
        }
        
        switch contentType {
        case .comment:
            return L10n.Activity.You.childPeerTopic(actor, content)
        case .reply:
            return L10n.Activity.You.childPeerComment(actor, content)
        default:
            Logger.log("Failed parsing", contentType , event: .veryImportant)
            return nil
        }
    }
    
    override func renderLike(item: ActivityView) -> String? {
        
        guard
            let contentType = item.actedOnContent?.contentType,
            let contentText = item.actedOnContent?.text,
            let actor = item.actorUsers?.first?.getFullName()
            
            else {
                Logger.log(item, "Failed parsing", event: .veryImportant)
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
            Logger.log("Failed parsing", contentType, event: .veryImportant)
            return nil
        }
    }
    
    override func renderFollowAccepted(item: ActivityView) -> String? {
        guard let actor = item.actorUsers?.first?.getFullName() else {
            return nil
        }

        return L10n.Activity.You.followAccepted(actor)
    }
    
    override func renderFollowing(item: ActivityView) -> String? {
        guard let actor = item.actorUsers?.first?.getFullName() else {
            return nil
        }
        
        return L10n.Activity.You.following(actor)
    }
}

class OthersActivityTextRender: BaseActivityTextRender {
    
    override func renderChild(item: ActivityView) -> String? {
        
        guard
            let content = item.actedOnContent?.text,
            let contentType = item.actedOnContent?.contentType,
            let actor = item.actorUsers?.first?.getFullName()
            else {
                Logger.log("Failed parsing", item, event: .veryImportant)
                return nil
        }
        
        switch contentType {
        case .topic:
            return L10n.Activity.Following.childTopic(actor, content)
        case .comment:
            return L10n.Activity.Following.childComment(actor, content)
        default:
            Logger.log("Failed parsing", contentType , event: .veryImportant)
            return nil
        }
    }
    
    override func renderPeer(item: ActivityView) -> String? {
        
        guard
            let content = item.actedOnContent?.text,
            let contentType = item.actedOnContent?.contentType,
            let actor = item.actorUsers?.first?.getFullName()
            else {
                Logger.log(item, "Failed parsing", event: .veryImportant)
                return nil
        }
        
        switch contentType {
        case .comment:
            return L10n.Activity.Following.childPeerTopic(actor, content)
        case .reply:
            return L10n.Activity.Following.childPeerComment(actor, content)
        default:
            Logger.log("Failed parsing", contentType , event: .veryImportant)
            return nil
        }
    }
    
    override func renderLike(item: ActivityView) -> String? {
        
        guard let contentType = item.actedOnContent?.contentType, let contentText = item.actedOnContent?.text, let actor = item.actorUsers?.first?.getFullName() else {
            return nil
        }
        
        switch contentType {
        case .comment:
            return L10n.Activity.Following.likeComment(actor, contentText)
        case .reply:
            return L10n.Activity.Following.likeReply(actor, contentText)
        case .topic:
            return L10n.Activity.Following.likeTopic(actor, contentText)
        default:
            return nil
        }
    }
    
    override func renderFollowing(item: ActivityView) -> String? {
        guard  let actor = item.actorUsers?.first?.getFullName(), let target = item.actedOnUser?.getFullName() else {
            return nil
        }
        
        return L10n.Activity.Following.following(actor, target)
    }
    
}

