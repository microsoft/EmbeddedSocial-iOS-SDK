//
//  CommentCellCommentCellInteractor.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class CommentCellInteractor: CommentCellInteractorInput {

    weak var output: CommentCellInteractorOutput!

    
    var likeService: LikesServiceProtocol?
    
    // MARK: Social Actions
    
    func commentAction(commentHandle: String, action: CommentSocialAction) {
        
        let completion: LikesServiceProtocol.CommentCompletionHandler = { [weak self] (handle, error) in
            self?.output?.didPostAction(action: action, error: error)
        }
        
        switch action {
        case .like:
            likeService?.likeComment(commentHandle: commentHandle, completion: completion)
        case .unlike:
            likeService?.unlikeComment(commentHandle: commentHandle, completion: completion)
        }
        
    }
    
    
}
