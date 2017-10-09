//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ReplyCellInteractorOutput: class {
    func didPostAction(replyHandle: String, action: RepliesSocialAction, error: Error?)
}

protocol ReplyCellInteractorInput {
    func replyAction(replyHandle: String, action: RepliesSocialAction)
}

class ReplyCellInteractor: ReplyCellInteractorInput {

    weak var output: ReplyCellInteractorOutput!
    
    var likeService: LikesServiceProtocol?
    
    private let userHolder: UserHolder
    
    init(userHolder: UserHolder = SocialPlus.shared) {
        self.userHolder = userHolder
    }
    
    func replyAction(replyHandle: String, action: RepliesSocialAction) {
        
        let completion: LikesServiceProtocol.CommentCompletionHandler = { [weak self] (handle, error) in
            self?.output?.didPostAction(replyHandle: replyHandle, action: action, error: error)
        }
        
        switch action {
        case .like:
            likeService?.likeReply(replyHandle: replyHandle, completion: completion)
        case .unlike:
            likeService?.unlikeReply(replyHandle: replyHandle, completion: completion)
        }
        
    }
    
    func didPostAction(replyHandle: String, action: RepliesSocialAction, error: Error?) {
        
    }

}
