//
//  CommentCellCommentCellPresenter.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol CommentCellModuleProtocol {
    func cell() -> CommentCell
    func mainComment() -> Comment
}

class CommentCellPresenter: CommentCellModuleInput, CommentCellViewOutput, CommentCellInteractorOutput {

    var view: CommentCellViewInput?
    var interactor: CommentCellInteractorInput?
    var router: CommentCellRouterInput?
    
    var comment: Comment!

    
    // MARK: CommentCellViewOutput
    func viewIsReady() {
        
    }
    
    func like() {
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
        guard let handle = comment.userHandle else {
            return
        }
        
        router?.openUser(userHandle: handle)
    }
    
    func mediaPressed() {
        guard let mediaURL = comment.mediaUrl else {
            return
        }
        
        router?.openImage(imageUrl: mediaURL)
    }
    
    deinit {
//        view = nil
        interactor = nil
        router = nil
        print("CommentCellPresenter deinit")
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
