//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ReplyCellModuleInput: class {
    
}

protocol ReplyCellModuleOutput: class {
    func removed(reply: Reply)
}

class ReplyCellPresenter: ReplyCellModuleInput, ReplyCellViewOutput, ReplyCellInteractorOutput {

    weak var view: ReplyCellViewInput?
    var interactor: ReplyCellInteractorInput?
    var router: ReplyCellRouterInput?
    
    var myProfileHolder: UserHolder?
    weak var moduleOutput: ReplyCellModuleOutput!
    
    var reply: Reply!

    func viewIsReady() {

    }
    
    func didPostAction(replyHandle: String, action: RepliesSocialAction, error: Error?) {
        
    }
    
    
    func like() {
        guard myProfileHolder?.me != nil else {
            router?.openLogin()
            return
        }
        let status = reply.liked
        let action: RepliesSocialAction = status ? .unlike : .like
        
        reply.liked = !status
        
        if action == .like {
            reply.totalLikes += 1
        } else if action == .unlike && reply.totalLikes > 0 {
            reply.totalLikes -= 1
        }
        
        view?.configure(reply: reply)
        interactor?.replyAction(replyHandle: reply.replyHandle, action: action)
    }
    
    func avatarPressed() {
        guard let handle = reply.user?.uid else {
            return
        }
        
        router?.openUser(userHandle: handle)
    }
    
    func likesPressed() {
        router?.openLikes(replyHandle: reply.replyHandle)
    }
    
    func optionsPressed() {
        let isMyComment = (myProfileHolder?.me?.uid == reply.user?.uid)
        
        if isMyComment {
            router?.openMyReplyOptions(reply: reply)
        } else {
            router?.openOtherReplyOptions(reply: reply)
        }
    }
}

extension ReplyCellPresenter: PostMenuModuleOutput {
    
    func postMenuProcessDidStart() {
        //        view.setRefreshingWithBlocking(state: true)
    }
    
    func postMenuProcessDidFinish() {
        //        view.setRefreshingWithBlocking(state: false)
    }
    
    func didBlock(user: User) {
        Logger.log("Success")
    }
    
    func didUnblock(user: User) {
        Logger.log("Success")
    }
    
    func didFollow(user: User) {
//        comment.userStatus = .accepted
//        view?.configure(comment: comment)
    }
    
    func didUnfollow(user: User) {
//        comment.userStatus = .empty
//        view?.configure(comment: comment)
    }
    
    func didRemove(reply: Reply) {
        moduleOutput.removed(reply: reply)
    }
    
    func didReport(post: PostHandle) {
        Logger.log("Not implemented")
    }
    
    func didRequestFail(error: Error) {
        Logger.log("Reloading feed", error, event: .error)
        //        view.showError(error: error)
        //        fetchAllItems()
    }
    
}
