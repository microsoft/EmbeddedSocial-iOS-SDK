//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class MenuViewModelBuilder {
    
    // PUBLIC
    
    func buildActionListForMyComment(comment: Comment, delegate: PostMenuModuleInput?) -> [ActionViewModel] {
        var removeitem = ActionViewModel()
        removeitem.title = L10n.PostMenu.removeComment
        removeitem.action = { _ in
            delegate?.didTapRemove(comment: comment)
        }
        
        return [removeitem]
    }
    
    func buildActionListForOtherComment(comment: Comment, delegate: PostMenuModuleInput?) -> [ActionViewModel] {
        let followItem = buildFollowersComment(comment: comment, delegate: delegate)
        let blockItem = buildBlockComment(comment: comment, delegate: delegate)
        
        var reportItem = ActionViewModel()
        reportItem.title = L10n.PostMenu.reportComment
        reportItem.action = { _ in
            delegate?.didTapReport(comment: comment)
        }
        
        let items = [followItem, blockItem, reportItem]
        
        return items
    }
    
    func buildActionListForMyReply(reply: Reply, delegate: PostMenuModuleInput?) -> [ActionViewModel] {
        var removeitem = ActionViewModel()
        removeitem.title = L10n.PostMenu.removeReply
        removeitem.action = { _ in
            delegate?.didTapRemove(reply: reply)
        }
        
        return [removeitem]
    }
    
    func buildActionListForOtherReply(reply: Reply, delegate: PostMenuModuleInput?) -> [ActionViewModel] {
        let followItem = buildFollowersReply(reply: reply, delegate: delegate)
        let blockItem = buildBlockReply(reply: reply, delegate: delegate)
        
        var reportItem = ActionViewModel()
        reportItem.title = L10n.PostMenu.reportReply
        reportItem.action = { _ in
            delegate?.didTapReport(reply: reply)
        }
        
        let items = [followItem, blockItem, reportItem]
        
        return items
    }
    
    
    // PRIVATE
    
    private func buildBlockReply(reply: Reply, delegate: PostMenuModuleInput?) -> ActionViewModel {
        var item = ActionViewModel()
        let userHandle = reply.userHandle!
        
        let shouldUnblock = reply.userStatus == .blocked
        
        item.title = shouldUnblock ? L10n.PostMenu.unblock : L10n.PostMenu.block
        item.action = { _ in
            if shouldUnblock {
                delegate?.didTapUnblock(user: User(uid: userHandle))
            } else {
                delegate?.didTapBlock(user: User(uid: userHandle))
            }
        }
        
        return item
    }
    
    private func buildFollowersReply(reply: Reply, delegate: PostMenuModuleInput?) -> ActionViewModel {
        var item = ActionViewModel()
        
        let shouldFollow = (reply.userStatus == .accepted) ? false : true
        
        item.title = shouldFollow ? L10n.PostMenu.follow : L10n.PostMenu.unfollow
        item.action = { _ in
            guard let user = reply.user else { return }

            if shouldFollow {
                delegate?.didTapFollow(user: user)
            } else {
                delegate?.didTapUnfollow(user: user)
            }
        }
        return item
    }

    private func buildBlockComment(comment: Comment, delegate: PostMenuModuleInput?) -> ActionViewModel {
        var item = ActionViewModel()
        let shouldUnblock = comment.userStatus == .blocked
        
        item.title = shouldUnblock ? L10n.PostMenu.unblock : L10n.PostMenu.block
        item.action = { _ in
            guard let user = comment.user else { return }

            if shouldUnblock {
                delegate?.didTapUnblock(user: user)
            } else {
                delegate?.didTapBlock(user: user)
            }
        }
        
        return item
    }
    
    private func buildFollowersComment(comment: Comment, delegate: PostMenuModuleInput?) -> ActionViewModel {
        var item = ActionViewModel()
        
        let shouldFollow = (comment.userStatus == .accepted) ? false : true
        
        item.title = shouldFollow ? L10n.PostMenu.follow : L10n.PostMenu.unfollow
        item.action = { _ in
            guard let user = comment.user else { return }
            
            if shouldFollow {
                delegate?.didTapFollow(user: user)
            } else {
                delegate?.didTapUnfollow(user: user)
            }
        }
        return item
    }
    
}
