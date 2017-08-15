//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostMenuModuleModuleOutput: class {

    func didChangeItems()
    func didChangeItem(user: UserHandle)
    func didChangeItem(post: PostHandle)
    func didRemoveItem(post: PostHandle)
    func didFail(_ error: Error)
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
    weak var output: PostMenuModuleModuleOutput?
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
        
    
        let followItem = followersViewModel(post: post)
        let blockItem = blockViewModel(post: post)
        
        var reportItem = ActionViewModel()
        reportItem.title = "Report Post"
        reportItem.action = { [weak self] in
            self?.interactor.report(post: post.topicHandle)
        }
        
        var items = [followItem, blockItem, reportItem]
        
        if isHomeFeed {
            let item = hideViewModel(post: post)
            items.append(item)
        }
        
        return items
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
        
        item.title = shouldFollow ? "Follow" : "Unfollow"
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
        
        let shouldUnblock = post.userStatus == .blocked
        
        item.title = shouldUnblock ? "Unblock" : "Block"
        item.action = { [weak self] in
            if shouldUnblock {
                self?.interactor.unblock(user: userHandle)
            } else {
                self?.interactor.block(user: userHandle)
            }
        }
        return item
    }
    
    private func hideViewModel(post: Post) -> ActionViewModel {
        
        var item = ActionViewModel()
        item.title = "Hide"
        item.action = { [weak self] in
            self?.interactor.hide(post: post.topicHandle)
        }
        
        return item
    }
    
    // MARK: View Output
    
    // MARK: Interactor Output
    func didBlock(user: UserHandle, error: Error?) {
        if let error = error {
            output?.didFail(error)
        } else {
            output?.didChangeItems()
        }
        Logger.log(user, error)
    }
    
    func didUnblock(user: UserHandle, error: Error?) {
        if let error = error {
            output?.didFail(error)
        } else {
            output?.didChangeItems()
        }
        Logger.log(user, error)
    }
    
    func didRepost(user: UserHandle, error: Error?) {
        Logger.log(user, error)
    }
    
    func didFollow(user: UserHandle, error: Error?) {
        if let error = error {
            output?.didFail(error)
        } else {
            output?.didChangeItems()
        }
        Logger.log(user, error)
    }
    
    func didUnfollow(user: UserHandle, error: Error?) {
        if let error = error {
            output?.didFail(error)
        } else {
            output?.didChangeItems()
        }
        Logger.log(user, error)
    }
    
    func didHide(post: PostHandle, error: Error?) {
        if let error = error {
            output?.didFail(error)
        } else {
            output?.didRemoveItem(post: post)
        }
        Logger.log(post, error)
    }
    
    func didEdit(post: PostHandle, error: Error?) {
        if let error = error {
            output?.didFail(error)
        } else {
            output?.didChangeItem(post: post)
        }
        Logger.log(post, error)
    }
    
    func didRemove(post: PostHandle, error: Error?) {
        if let error = error {
            output?.didFail(error)
        } else {
            output?.didRemoveItem(post: post)
        }
        Logger.log(post, error)
    }
    
    func didReport(post: PostHandle, error: Error?) {
        Logger.log(post, error)
    }
    
}
