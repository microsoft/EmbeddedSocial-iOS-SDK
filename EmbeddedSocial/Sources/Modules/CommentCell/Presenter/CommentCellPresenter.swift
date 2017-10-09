//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CommentCellModuleProtocol {
    func cell() -> CommentCell
    func mainComment() -> Comment
}

protocol CommentCellModuleOutout: class {
    func removed(comment: Comment)
}

class CommentCellPresenter: CommentCellModuleInput, CommentCellViewOutput, CommentCellInteractorOutput {
    
    var view: CommentCellViewInput?
    var interactor: CommentCellInteractorInput?
    var router: CommentCellRouterInput?
    var myProfileHolder: UserHolder?
    
    weak var moduleOutput: CommentCellModuleOutout?
    
    var comment: Comment!
    
    // MARK: CommentCellViewOutput
    func viewIsReady() {
     
        
    }
    
    func like() {
        guard myProfileHolder?.me != nil else {
            router?.openLogin()
            return
        }
        let status = comment.liked
        let action: CommentSocialAction = status ? .unlike : .like

        comment.liked = !status

        if action == .like {
            comment.totalLikes += 1
        } else if action == .unlike && comment.totalLikes > 0 {
            comment.totalLikes -= 1
        }

        view?.configure(comment: comment)
        interactor?.commentAction(commentHandle: comment.commentHandle, action: action)
    }
    
    func toReplies(scrollType: RepliesScrollType) {
        router?.openReplies(scrollType: scrollType, commentModulePresenter: self)
    }
    
    func avatarPressed() {
        guard let handle = comment.user?.uid else {
            return
        }
        
        router?.openUser(userHandle: handle)
    }
    
    func likesPressed() {
        router?.openLikes(commentHandle: comment.commentHandle)
    }
    
    func mediaPressed() {
        guard let mediaURL = comment.mediaPhoto?.url else {
            return
        }
        
        router?.openImage(imageUrl: mediaURL)
    }
    
    func optionsPressed() {
        let isMyComment = (SocialPlus.shared.me?.uid == comment.user?.uid)
        
        if isMyComment {
            router?.openMyCommentOptions(comment: comment)
        } else {
            router?.openOtherCommentOptions(comment: comment)
        }
    }
    
    // MARK: CommentCellInteractorOutput
    func didPostAction(action: CommentSocialAction, error: Error?) {
        if error != nil {
            
        }
    }
    
}

extension CommentCellPresenter: CommentCellModuleProtocol {
    func cell() -> CommentCell {
        return view as! CommentCell
    }
    
    func mainComment() -> Comment {
        return comment
    }
}

extension CommentCellPresenter: PostMenuModuleOutput {
    
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
        comment.userStatus = .accepted
        view?.configure(comment: comment)
    }
    
    func didUnfollow(user: User) {
        comment.userStatus = .empty
        view?.configure(comment: comment)
    }
    
    func didRemove(comment: Comment) {
         moduleOutput?.removed(comment: comment)
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
