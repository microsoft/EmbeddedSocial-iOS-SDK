//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

enum RepliesCellAction {
    case like, profile, toLikes, extra
}

struct ReplyViewModel {
    
    typealias ActionHandler = (RepliesCellAction, Int) -> Void
    
    var userName: String = ""
    var userHandle: String = ""
    var title: String = ""
    var text: String = ""
    var isLiked: Bool = false
    var totalLikes: String = ""
    var timeCreated: String = ""
    var userImageUrl: String? = nil
    var replyHandle: String = ""
    
    var cellType: String = ReplyCell.reuseID
    var onAction: ActionHandler?
}

class CommentRepliesPresenter: CommentRepliesModuleInput, CommentRepliesViewOutput, CommentRepliesInteractorOutput {

    var view: CommentRepliesViewInput?
    var interactor: CommentRepliesInteractorInput!
    var router: CommentRepliesRouterInput!
    
    var comment: Comment! {
        didSet {
            print(comment)
        }
    }
    
    var scrollType: RepliesScrollType = .none
    
    var replies = [Reply]()
    
    private var formatter = DateFormatterTool()
    fileprivate var shouldFetchRestOfReplies = false
    var loadMoreCellViewModel = LoadMoreCellViewModel()
    
    var cursor: String?
    var commentModuleOutput: CommentCellModuleProtocol!
    private let pageSize: Int
    private let actionStrategy: AuthorizedActionStrategy
    
    init(pageSize: Int,
         actionStrategy: AuthorizedActionStrategy,
         handlePublisher: Publisher = HandleChangesMulticast.shared) {
        self.pageSize = pageSize
        self.actionStrategy = actionStrategy
        handlePublisher.subscribe(self)
    }
    
    // MARK: CommentRepliesViewOutput
    
    func loadCellModel() -> LoadMoreCellViewModel {
        return loadMoreCellViewModel
    }
    
    func mainComment() -> Comment {
        return comment
    }
    
    func refresh() {
        cursor = nil
        scrollType = .none
        loadMoreCellViewModel.cellHeight = LoadMoreCell.cellHeight
        loadMoreCellViewModel.startLoading()
        interactor.fetchReplies(commentHandle: comment.commentHandle, cursor: cursor, limit: pageSize)
    }
    
    func reply(index: Int) -> Reply {
        return replies[index]
    }
    
    func canFetchMore() -> Bool {
        if cursor == nil || cursor == "" {
            return false
        }
        
        return true
    }
    
    func viewIsReady() {
        guard let commentHandle = comment.commentHandle else {
            return
        }
        
        interactor.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: pageSize)
    }
    
    func fetchMore() {
        loadMoreCellViewModel.startLoading()
        view?.updateLoadingCell()
        interactor.fetchMoreReplies(commentHandle: comment.commentHandle, cursor: cursor, limit: pageSize)
    }
    
    func loadRestReplies() {
        shouldFetchRestOfReplies = true
        scrollType = .bottom
        if cursor == nil {
            view?.reloadTable(scrollType: scrollType)
        } else {
            shouldFetchRestOfReplies = true
            fetchMore()
        }
    }
    
    func numberOfItems() -> Int {
        return replies.count
    }
    
    func postReply(text: String) {
        actionStrategy.executeOrPromptLogin { [weak self] in self?._postReply(text: text) }
    }
    
    func _postReply(text: String) {
        view?.lockUI()
        interactor.postReply(commentHandle: comment.commentHandle, text: text)
    }
    
    private func enableFetchMore() {
        loadMoreCellViewModel.cellHeight = LoadMoreCell.cellHeight
        view?.updateLoadingCell()
    }
    
    private func stopLoading() {
        if cursor == nil {
            loadMoreCellViewModel.cellHeight = 0.1
        } else {
            loadMoreCellViewModel.cellHeight = LoadMoreCell.cellHeight
        }
        
        loadMoreCellViewModel.stopLoading()
    }
    
    // MARK: CommentRepliesInteractorOutput
    
    func fetchedFailed(error: Error) {
        loadMoreCellViewModel.cellHeight = 0.1
        loadMoreCellViewModel.stopLoading()
        view?.updateLoadingCell()
        view?.unlockUI()
    }
    
    func fetched(replies: [Reply], cursor: String?) {
        self.cursor = cursor
        self.replies = replies
        self.replies.sort(by: { $0.0.createdTime! < $0.1.createdTime! })
        stopLoading()
        view?.reloadTable(scrollType: scrollType)
    }
    
    func fetchedMore(replies: [Reply], cursor: String?) {
        self.cursor = cursor
        appendWithReplacing(original: &self.replies, appending: replies)
        self.replies.sort(by: { $0.0.createdTime! < $0.1.createdTime! })
        stopLoading()
        if cursor != nil && shouldFetchRestOfReplies == true {
            self.fetchMore()
        } else if shouldFetchRestOfReplies == true {
            view?.reloadTable(scrollType: .bottom)
            shouldFetchRestOfReplies = false
        } else {
            view?.reloadReplies()
            view?.updateLoadingCell()
        }
    }
    
    private func appendWithReplacing(original: inout [Reply], appending: [Reply]) {
        for appendingItem in appending {
            if let index = original.index(where: { $0.replyHandle == appendingItem.replyHandle }) {
                original[index] = appendingItem
            } else {
                original.append(appendingItem)
            }
        }
    }
    
    func replyPosted(reply: Reply) {
        if replies.contains(where: { $0.replyHandle == reply.replyHandle } ) {
            return
        }
        
        reply.userHandle = SocialPlus.shared.me?.uid
        appendWithReplacing(original: &replies, appending: [reply])
        comment.totalReplies += 1
        view?.replyPosted()
        view?.reloadCommentCell()
    }
    
    func replyFailPost(error: APIError) {
        if error == .commentNotFound {
            router.back()
        }
        
        view?.unlockUI()
    }
    
    func didPostAction(replyHandle: String, action: RepliesSocialAction, error: Error?) {
        
        if error != nil {
            
            guard let index = replies.enumerated().first(where: { $0.element.replyHandle == replyHandle })?.offset else {
                return
            }
            
            view?.refreshReplyCell(index: index)
        }
        
    }
}

extension CommentRepliesPresenter: Subscriber {
    
    func update(_ hint: Hint) {
        if let hint = hint as? CommentUpdateHint, comment.commentHandle == hint.oldHandle {
            comment.commentHandle = hint.newHandle
        } else if let hint = hint as? ReplyUpdateHint {
            updateReplyHandle(from: hint.oldHandle, to: hint.newHandle)
        }
    }
    
    private func updateReplyHandle(from oldHandle: String, to newHandle: String) {
        guard let idx = replies.index(where: { $0.replyHandle == oldHandle }) else { return }
        
        let replyToUpdate = replies[idx]
        replyToUpdate.replyHandle = newHandle
        replies[idx] = replyToUpdate
    }
}

extension CommentRepliesPresenter: ReplyCellModuleOutput {
    func removed(reply: Reply) {
        guard let index = replies.index(where: { $0.replyHandle == reply.replyHandle }) else {
            return
        }
        
        if comment.totalReplies > 0 {
            comment.totalReplies -= 1
        }
        replies.remove(at: index)
        router.backIfNeeded(from: view as! UIViewController)
        view?.removeReply(index: index)
        view?.reloadCommentCell()
    }
    
    func showMenu(reply: Reply) {
        let isMyComment = (SocialPlus.shared.me?.uid == reply.user?.uid)
        
        if isMyComment {
            router?.openMyReplyOptions(reply: reply)
        } else {
            router?.openOtherReplyOptions(reply: reply)
        }
    }
}

extension CommentRepliesPresenter: CommentCellModuleOutout {
    func removed(comment: Comment) {
        //todo: handle
        commentModuleOutput.didRemove(comment: comment)
        router.back()
    }
    
    func showMenu(comment: Comment) {
        
    }
    
    var shouldOpenMenu: Bool {
        return false
    }
}

extension CommentRepliesPresenter: PostMenuModuleOutput {
    
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
    
    func didRemove(reply: Reply) {
        guard let index = replies.index(where: { $0.replyHandle == reply.replyHandle }) else {
            return
        }
        
        replies.remove(at: index)
        comment.totalReplies -= 1
        view?.removeReply(index: index)
        view?.reloadCommentCell()
    }
    
    func didFollow(user: User) {
        for (index, item) in replies.enumerated() {
            if item.userHandle == user.uid {
                replies[index].userStatus = .accepted
                view?.refreshReplyCell(index: index)
                return
            }
        }
    }
    
    func didUnfollow(user: User) {
        for (index, item) in replies.enumerated() {
            if item.userHandle == user.uid && item.userStatus == .accepted {
                replies[index].userStatus = .empty
                view?.refreshReplyCell(index: index)
                return
            }
        }
    }
    
    func didRequestFail(error: Error) {
        Logger.log("Reloading feed", error, event: .error)
    }
}
