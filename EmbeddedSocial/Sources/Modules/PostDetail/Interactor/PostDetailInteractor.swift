//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

enum CommentSocialAction: Int {
    case like, unlike
}

class PostDetailInteractor: PostDetailInteractorInput {

    weak var output: PostDetailInteractorOutput?
    
    var commentsService: CommentServiceProtocol? {
        didSet {
            commentsService?.subscribe(self)
        }
    }
    
    var topicService: PostServiceProtocol?
    
    var isLoading = false
    
    private let userHolder: UserHolder
    
    init(userHolder: UserHolder = SocialPlus.shared) {
        self.userHolder = userHolder
    }
    
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32) {
        guard !isLoading else { return }
        
        isLoading = true
        
        commentsService?.fetchComments(
            topicHandle: topicHandle,
            cursor: cursor, limit: limit,
            cachedResult: { [weak self] (cachedResult) in
                if !cachedResult.comments.isEmpty {
                    self?.fetchedItems(result: cachedResult)
                }
            },
            resultHandler: { [weak self] in self?.fetchedItems(result: $0) }
        )
    }

    private func fetchedItems(result: CommentFetchResult) {
        isLoading = false
        
        guard result.error == nil else {
            output?.didFail(error: result.error!)
            return
        }
        
        output?.didFetch(comments: result.comments, cursor: result.cursor)
    }
    
    func fetchMoreComments(topicHandle: String, cursor: String?, limit: Int32) {
        let shouldIgnoreResponse = cursor == "" || cursor == nil || isLoading == true
        guard !shouldIgnoreResponse else { return }
        
        isLoading = true
        
        commentsService?.fetchComments(
            topicHandle: topicHandle,
            cursor: cursor, limit: limit,
            cachedResult: { [weak self] (cachedResult) in
                if !cachedResult.comments.isEmpty {
                    self?.fetchedMoreItems(result: cachedResult)
                }
            },
            resultHandler: { [weak self] in self?.fetchedMoreItems(result: $0) }
        )
    }
    
    private func fetchedMoreItems(result: CommentFetchResult) {
        isLoading = false
        
        guard result.error == nil else {
            output?.didFail(error: result.error!)
            return
        }
        
        output?.didFetchMore(comments: result.comments, cursor: result.cursor)
    }
    
    func postComment(photo: Photo?, topicHandle: String, comment: String) {
        let newComment = Comment(text: comment, photo: photo, topicHandle: topicHandle)
        newComment.user = userHolder.me

        commentsService?.postComment(
            comment: newComment,
            photo: photo,
            resultHandler: { [weak self] in self?.output?.commentDidPost(comment: $0) },
            failure: { [weak self] in self?.output?.commentPostFailed(error: $0) }
        )
    }
    
}

extension PostDetailInteractor: Subscriber {
    
    func update(_ hint: Hint) {
        if let h = hint as? CommentUpdateHint {
            output?.didUpdateCommentHandle(from: h.oldHandle, to: h.newHandle)
        }
    }
}
