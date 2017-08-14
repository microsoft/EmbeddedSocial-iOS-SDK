//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostMenuModuleModuleOutput: class {

    

}

protocol PostMenuModuleModuleInput: class {
    
}

enum PostMenuType {
    case myPost(post: Post)
    case otherPost(post: Post, isHome: Bool)
}

struct ActionViewModel {
    
    typealias ActionHandler = () -> ()
    
    var title: String = ""
    var action: ActionHandler!
}

class PostMenuModulePresenter: PostMenuModuleViewOutput, PostMenuModuleModuleInput, PostMenuModuleInteractorOutput {

    weak var view: PostMenuModuleViewInput!
    var interactor: PostMenuModuleInteractorInput!
    var router: PostMenuModuleRouterInput!
    var menuType: PostMenuType!
    
    func viewIsReady() {
        let items = itemsForMenu(type: menuType)
        view.showItems(items: items)
    }
    
    // MARK: Actions
    private func itemsForMenu(type: PostMenuType) -> [ActionViewModel] {
        switch type {
        case .myPost(let post):
            return buildActionListForMyPost(post: post)
        case .otherPost(let post, let isHomeFeed):
            return buildActionListForOtherPost(post: post, isHomeFeed: isHomeFeed)
        }
    }
    
    private func buildActionListForOtherPost(post: Post, isHomeFeed: Bool) -> [ActionViewModel] {
        
        let userHandle = post.userHandle!
        
        let followItem = followersViewModel(post: post)
        let blockItem = blockViewModel(post: post)
        
        var reportItem = ActionViewModel()
        reportItem.title = "Report Post"
        reportItem.action = { [weak self] in
            self?.interactor.repost(user: userHandle)
        }

        return [followItem, blockItem, reportItem]
    }

    private func buildActionListForMyPost(post: Post) -> [ActionViewModel] {
        
        let postHandle = post.topicHandle!
        
        var editItem = ActionViewModel()
        editItem.title = "Edit Post"
        editItem.action = { [weak self] in
            self?.interactor.edit(post: postHandle)
        }
        
        var removeitem = ActionViewModel()
        removeitem.title = "Remove Post"
        removeitem.action = { [weak self] in
            self?.interactor.remove(post: postHandle)
        }
        
        return [editItem, removeitem]
    }
    
    // MARK: View Models builder
    
    private func followersViewModel(post: Post) -> ActionViewModel {
        
        var item = ActionViewModel()
        
        let shouldFollow = (post.userStatus == Post.UserStatus.follow) ? false : true
        let userHandle = post.userHandle!
        
        item.title = shouldFollow ? "Unfollow" : "Follow"
        item.action = { [weak self] in
            if shouldFollow {
                self?.interactor.follow(user: userHandle)
            } else {
                self?.interactor.unfollow(user: userHandle)
            }
        }
        return item
    }
    
    private func blockViewModel(post: Post) -> ActionViewModel {
        
        var item = ActionViewModel()
        let userHandle = post.userHandle!
        
        let shouldUnBlock = post.userStatus == .blocked
        
        item.title = shouldUnBlock ? "Unblock" : "Block"
        item.action = { [weak self] in
            if shouldUnBlock {
                self?.interactor.unblock(user: userHandle)
            } else {
                self?.interactor.block(user: userHandle)
            }
        }
        return item
    }
    
    
    
    // MARK: View Output
    
    // MARK: Interactor Output
    func didBlock(user: UserHandle, error: Error?) {
        Logger.log(user, error)
    }
    
    func didUnblock(user: UserHandle, error: Error?) {
        Logger.log(user, error)
    }
    
    func didRepost(user: UserHandle, error: Error?) {
        Logger.log(user, error)
    }
    
    func didFollow(user: UserHandle, error: Error?) {
        Logger.log(user, error)
    }
    
    func didUnFollow(user: UserHandle, error: Error?) {
        Logger.log(user, error)
    }
    
    func didHide(post: PostHandle, error: Error?) {
        Logger.log(post, error)
    }
    
    func didEdit(post: PostHandle, error: Error?) {
        Logger.log(post, error)
    }
    
    func didRemove(post: PostHandle, error: Error?) {
        Logger.log(post, error)
    }
    
    func didReport(post: PostHandle, error: Error?) {
        Logger.log(post, error)
    }
    
}
