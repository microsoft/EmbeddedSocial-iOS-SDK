//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
