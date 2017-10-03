//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum RepliesSocialAction: Int {
    case like, unlike
}

class CommentRepliesInteractor: CommentRepliesInteractorInput {

    weak var output: CommentRepliesInteractorOutput?
    private var isLoading = false
    
    var repliesService: RepliesServiceProtcol?
    var likeService: LikesServiceProtocol?
    
    private let userHolder: UserHolder
    
    init(userHolder: UserHolder = SocialPlus.shared) {
        self.userHolder = userHolder
    }
    
    // MARK: Social Actions
    
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
    
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int) {
        self.isLoading = true
        self.repliesService?.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: limit, cachedResult: { (cachedResult) in
            if !cachedResult.replies.isEmpty {
                self.handleRepliesResult(result: cachedResult)
            }
        }, resultHandler: { (webResult) in
            self.handleRepliesResult(result: webResult)
        })

    }
    
    private func handleRepliesResult(result: RepliesFetchResult) {
        guard result.error == nil else {
            self.output?.fetchedFailed(error: result.error!)
            return
        }
        
        self.isLoading = false
        self.output?.fetched(replies: result.replies,  cursor: result.cursor)
    }
    
    func fetchMoreReplies(commentHandle: String, cursor: String?, limit: Int) {
        if cursor == "" || cursor == nil || self.isLoading == true {
            return
        }
        
        self.isLoading = true
        self.repliesService?.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: limit, cachedResult: { (cachedResult) in
            if !cachedResult.replies.isEmpty {
                self.handleMoreRepliesResult(result: cachedResult)
            }
        }, resultHandler: { (webResult) in
            self.handleMoreRepliesResult(result: webResult)
        })
    }
    
    private func handleMoreRepliesResult(result: RepliesFetchResult) {
        guard result.error == nil else {
            self.output?.fetchedFailed(error: result.error!)
            return
        }
        
        self.isLoading = false
        self.output?.fetchedMore(replies: result.replies, cursor: result.cursor)
    }
    
    func postReply(commentHandle: String, text: String) {
        let reply = Reply(replyHandle: UUID().uuidString)
        reply.commentHandle = commentHandle
        reply.text = text
        reply.userHandle = userHolder.me?.uid
        reply.userStatus = userHolder.me?.followerStatus ?? .empty
        reply.userLastName = userHolder.me?.lastName
        reply.userFirstName = userHolder.me?.firstName
        reply.userPhotoUrl = userHolder.me?.photo?.url
        reply.createdTime = Date()
        
        repliesService?.postReply(reply: reply, success: { (response) in
            reply.replyHandle = response.replyHandle
            self.output?.replyPosted(reply: reply)
        }, failure: { (error) in
            self.output?.replyFailPost(error: error)
        })
    }

    
}
