//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostMenuModuleInteractorInput {

    func block(user: UserHandle)
    func unblock(user: UserHandle)
    func follow(user: UserHandle)
    func unfollow(user: UserHandle)
    func hide(post: PostHandle)
    func edit(post: PostHandle)
    func remove(post: PostHandle)
    func remove(comment: Comment)
    func remove(reply: Reply)
    
}

protocol PostMenuModuleInteractorOutput: class {
    
    func didBlock(user: UserHandle, error: Error?)
    func didUnblock(user: UserHandle, error: Error?)
    func didFollow(user: UserHandle, error: Error?)
    func didUnfollow(user: UserHandle, error: Error?)
    func didHide(post: PostHandle, error: Error?)
    func didEdit(post: PostHandle, error: Error?)
    func didRemove(post: PostHandle, error: Error?)
    func didRemove(comment: Comment, error: Error?)
    func didRemove(reply: Reply, error: Error?)
    
}

class PostMenuModuleInteractor: PostMenuModuleInteractorInput {
    
    weak var output: PostMenuModuleInteractorOutput!
    var socialService: SocialServiceType!
    var topicsService: PostServiceProtocol!
    var commentService: CommentServiceProtocol!
    var repliesService: RepliesServiceProtcol!
    
    // MARK: Input
    
    func follow(user: UserHandle) {
        socialService.follow(userID: user) { [weak self] (result) in
            self?.output.didFollow(user: user, error: result.error)
        }
    }
    
    func unfollow(user: UserHandle) {
        socialService.unfollow(userID: user) { [weak self] (result) in
            self?.output.didUnfollow(user: user, error: result.error)
        }
    }
    
    func remove(post: PostHandle) {
        topicsService.deletePost(post: post) { [weak self] (result) in
            self?.output.didRemove(post: post, error: result.error)
        }
    }
    
    func remove(comment: Comment) {
        commentService.deleteComment(commentHandle: comment.commentHandle) { [weak self] (result) in
            self?.output.didRemove(comment: comment, error: result.error)
        }
    }
    
    func remove(reply: Reply) {
        repliesService.delete(replyHandle: reply.replyHandle) { [weak self] (result) in
            self?.output.didRemove(reply: reply, error: result.error)
        }
    }
    
    func block(user: UserHandle) {
        socialService.block(userID: user) { [weak self] (result) in
            self?.output.didBlock(user: user, error: result.error)
        }
    }
    
    func unblock(user: UserHandle) {
        socialService.unblock(userID: user) { [weak self] (result) in
            self?.output.didUnblock(user: user, error: result.error)
        }
    }
    
    func edit(post: PostHandle) {
        self.output.didEdit(post: post, error: nil)
    }
    
    func hide(post: PostHandle) {
        socialService.deletePostFromMyFollowing(postID: post) { [strongOutput = output!] (result) in
            strongOutput.didHide(post: post, error: result.error)
        }
    }
    
    deinit {
        Logger.log()
    }
}
