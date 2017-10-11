//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostMenuModuleOutput: class {

    func didBlock(user: User)
    func didUnblock(user: User)
    func didFollow(user: User)
    func didUnfollow(user: User)
    func didHide(post: PostHandle)
    func didEdit(post: PostHandle)
    func didRemove(post: PostHandle)
    func didRemove(comment: Comment)
    func didRemove(reply: Reply)
    func didReport(post: PostHandle)
    func didReport(comment: Comment)
    func didReport(reply: Reply)
    func didRequestFail(error: Error)
    func postMenuProcessDidStart()
    func postMenuProcessDidFinish()
}

extension PostMenuModuleOutput {
    func didHide(post: PostHandle) {}
    func didEdit(post: PostHandle) {}
    func didRemove(post: PostHandle) {}
    func didRemove(comment: Comment) {}
    func didRemove(reply: Reply) {}
    func didReport(post: PostHandle) {}
    func didReport(comment: Comment) {}
    func didReport(reply: Reply) {}
}

protocol PostMenuModuleInput: class {
    
    func didTapBlock(user: User)
    func didTapUnblock(user: User)
    func didTapHide(post: PostHandle)
    func didTapFollow(user: User)
    func didTapUnfollow(user: User)
    func didTapEditPost(post: Post)
    func didTapRemovePost(post: PostHandle)
    func didTapReport(comment: Comment)
    func didTapReport(reply: Reply)
    func didTapRemove(comment: Comment)
    func didTapRemove(reply: Reply)
}

enum PostMenuType: CustomStringConvertible {
    case myPost(post: Post)
    case otherPost(post: Post, isHome: Bool)
    case myComment(comment: Comment)
    case otherComment(comment: Comment)
    case myReply(reply: Reply)
    case otherReply(reply: Reply)
    
    var description: String  {
        get {
            switch self {
            case .myPost(let post ), .otherPost(let post, _):
                return post.topicHandle
            case .myComment(let comment), .otherComment(let comment):
                return comment.commentHandle
            case .myReply(let reply), .otherReply(let reply):
                return reply.replyHandle
            }
        }
    }
}

struct ActionViewModel {
    
    typealias ActionHandler = () -> ()
    
    var title: String = ""
    var action: ActionHandler!
}

class PostMenuModulePresenter: PostMenuModuleViewOutput, PostMenuModuleInput, PostMenuModuleInteractorOutput {

    weak var view: PostMenuModuleViewInput!
    weak var output: PostMenuModuleOutput?
    var interactor: PostMenuModuleInteractorInput!
    var router: PostMenuModuleRouterInput!
    var menuType: PostMenuType!
    
    private let actionStrategy: AuthorizedActionStrategy

    init(actionStrategy: AuthorizedActionStrategy) {
        self.actionStrategy = actionStrategy
    }
    
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
        case .myComment(let comment):
            return MenuViewModelBuilder().buildActionListForMyComment(comment: comment, delegate: self)
        case .otherComment(let comment):
            return MenuViewModelBuilder().buildActionListForOtherComment(comment: comment, delegate: self)
        case .myReply(let reply):
            return MenuViewModelBuilder().buildActionListForMyReply(reply: reply, delegate: self)
        case .otherReply(let reply):
            return MenuViewModelBuilder().buildActionListForOtherReply(reply: reply, delegate: self)
        }
    }
    
    private func buildActionListForOtherPost(post: Post, isHomeFeed: Bool) -> [ActionViewModel] {
        
        let followItem = followersViewModel(post: post)
        let blockItem = blockViewModel(post: post)
        
        var reportItem = ActionViewModel()
        reportItem.title = L10n.PostMenu.report
        reportItem.action = { [weak self] in
            self?.didTapReportPost(post: post.topicHandle)
        }
        
        var items = [followItem, blockItem, reportItem]
        
        if isHomeFeed {
            let item = hideViewModel(post: post)
            items.append(item)
        }
        
        return items
    }

    private func buildActionListForMyPost(post: Post) -> [ActionViewModel] {
        
        let postHandle = post.topicHandle
        
        var editItem = ActionViewModel()
        editItem.title = L10n.PostMenu.edit
        editItem.action = { [weak self] in
            self?.didTapEditPost(post: post)
        }
        
        var removeitem = ActionViewModel()
        removeitem.title = L10n.PostMenu.remove
        removeitem.action = { [weak self] in
            self?.didTapRemovePost(post: postHandle)
        }
        
        return [editItem, removeitem]
    }
    
    
    // MARK: View Models builder
    
    private func followersViewModel(post: Post) -> ActionViewModel {
        
        var item = ActionViewModel()
        
        let shouldFollow = (post.userStatus == .accepted) ? false : true
        
        item.title = shouldFollow ? L10n.PostMenu.follow : L10n.PostMenu.unfollow
        
        item.action = { [weak self] in
            let user = post.user
            
            if shouldFollow {
                self?.didTapFollow(user: user)
            } else {
                self?.didTapUnfollow(user: user)
            }
        }
        return item
    }
    
    private func blockViewModel(post: Post) -> ActionViewModel {
        
        var item = ActionViewModel()
        
        let shouldUnblock = post.userStatus == .blocked
        
        item.title = shouldUnblock ? L10n.PostMenu.unblock : L10n.PostMenu.block
        item.action = { [weak self] in
            
            let user = post.user

            if shouldUnblock {
                self?.didTapUnblock(user: user)
            } else {
                self?.didTapBlock(user: user)
            }
        }
        return item
    }
    
    private func hideViewModel(post: Post) -> ActionViewModel {
        
        var item = ActionViewModel()
        item.title = L10n.PostMenu.hide
        item.action = { [weak self] in
            self?.didTapHide(post: post.topicHandle)
        }
        
        return item
    }
    
    // MARK: Module Input
    func didTapBlock(user: User) {
        actionStrategy.executeOrPromptLogin { [weak self] in self?._didTapBlock(user: user) }
    }
    
    private func _didTapBlock(user: User) {
        output?.didBlock(user: user)
        interactor.block(user: user)
    }
    
    func didTapUnblock(user: User) {
        self.output?.didUnblock(user: user)
        self.interactor.unblock(user: user)
    }
    
    func didTapHide(post: PostHandle) {
        self.output?.didHide(post: post)
        self.interactor.hide(post: post)
    }
    
    func didTapFollow(user: User) {
        actionStrategy.executeOrPromptLogin { [weak self] in self?._didTapFollow(user: user) }
    }
    
    private func _didTapFollow(user: User) {
        output?.postMenuProcessDidStart()
        interactor.follow(user: user)
    }
    
    func didTapUnfollow(user: User) {
        self.output?.postMenuProcessDidStart()
        self.interactor.unfollow(user: user)
    }
    
    func didTapEditPost(post: Post) {
        self.router.openEdit(post: post)
    }
    
    func didTapRemovePost(post: PostHandle) {
        self.output?.didRemove(post: post)
        self.interactor.remove(post: post)
    }
    
    func didTapRemove(comment: Comment) {
        self.output?.didRemove(comment: comment)
        self.interactor.remove(comment: comment)
    }
    
    func didTapRemove(reply: Reply) {
        self.output?.didRemove(reply: reply)
        self.interactor.remove(reply: reply)
    }
    
    func didTapReportPost(post: PostHandle) {
        self.output?.didReport(post: post)
       router.openReport(postHandle: post)
    }
    
    func didTapReport(comment: Comment) {
        self.output?.didReport(comment: comment)
        router.openReport(comment: comment)
    }
    
    func didTapReport(reply: Reply) {
        self.output?.didReport(reply: reply)
        router.openReport(reply: reply)
    }
    
    // MARK: Interactor Output
    
    func didRemove(reply: Reply, error: Error?) {
        output?.postMenuProcessDidFinish()
        if let error = error {
            output?.didRequestFail(error: error)
        } else {
            output?.didRemove(reply: reply)
        }
    }
    
    func didRemove(comment: Comment, error: Error?) {
        output?.postMenuProcessDidFinish()
        if let error = error {
            output?.didRequestFail(error: error)
        } else {
            output?.didRemove(comment: comment)
        }
    }
    
    func didBlock(user: User, error: Error?) {
        Logger.log(user, error)
        if let error = error {
            output?.didRequestFail(error: error)
        }
    }
    
    func didUnblock(user: User, error: Error?) {
        Logger.log(user, error)
        if let error = error {
            output?.didRequestFail(error: error)
        }
    }
    
    func didFollow(user: User, error: Error?) {
        Logger.log(user, error)
        output?.postMenuProcessDidFinish()
        if let error = error {
            output?.didRequestFail(error: error)
        } else {
            output?.didFollow(user: user)
        }
    }
    
    func didUnfollow(user: User, error: Error?) {
        Logger.log(user, error)
        output?.postMenuProcessDidFinish()
        if let error = error {
            output?.didRequestFail(error: error)
        } else {
            output?.didUnfollow(user: user)
        }
    }
    
    func didHide(post: PostHandle, error: Error?) {
        Logger.log(post, error)
        if let error = error {
            output?.didRequestFail(error: error)
        }
    }
    
    func didEdit(post: PostHandle, error: Error?) {
        Logger.log(post, error)
        if let error = error {
            output?.didRequestFail(error: error)
        }
    }
    
    func didRemove(post: PostHandle, error: Error?) {
        Logger.log(post, error)
        if let error = error {
            output?.didRequestFail(error: error)
        }
    }
    
    deinit {
        Logger.log(menuType)
    }
}
