//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class PostDetailPresenter: PostDetailViewOutput, PostDetailInteractorOutput, PostDetailModuleInput {

    weak var view: PostDetailViewInput!
    var interactor: PostDetailInteractorInput!
    var router: PostDetailRouterInput!
    var scrollType: CommentsScrollType = .none
    
    var feedViewController: UIViewController?
    var feedModuleInput: FeedModuleInput?

    var comments = [Comment]()
    
    var topicHandle: PostHandle!
    
    private var formatter = DateFormatterTool()
    private var cursor: String?
    private var shouldFetchRestOfComments = false
    
    fileprivate var dataIsFetching = false
    fileprivate var loadMoreCellViewModel = LoadMoreCellViewModel()
    
    private let pageSize: Int
    private let actionStrategy: AuthorizedActionStrategy
    
    private let userHolder: UserHolder
    
    func heightForFeed() -> CGFloat {
        return (feedModuleInput?.moduleHeight())!
    }
    
    init(pageSize: Int,
         actionStrategy: AuthorizedActionStrategy,
         userHolder: UserHolder = SocialPlus.shared,
         handleChangesPublisher: Publisher = HandleChangesMulticast.shared) {
        
        self.userHolder = userHolder
        self.pageSize = pageSize
        self.actionStrategy = actionStrategy
        handleChangesPublisher.subscribe(self)
    }
    
    // MARK: PostDetailInteractorOutput
    
    func didFetch(comments: [Comment], cursor: String?) {
        self.cursor = cursor
        self.comments = comments
        self.comments.sort(by: { $0.0.createdTime! < $0.1.createdTime! })
        stopLoading()
        view.reloadTable(scrollType: scrollType)
    }
    
    func didFetchMore(comments: [Comment], cursor: String?) {
        dataIsFetching = false
        appendWithReplacing(original: &self.comments, appending: comments)
        self.comments.sort(by: { $0.0.createdTime! < $0.1.createdTime! })
        self.cursor = cursor
        stopLoading()
        if cursor != nil && shouldFetchRestOfComments == true {
            self.fetchMore()
        } else if shouldFetchRestOfComments == true {
            view.reloadTable(scrollType: .bottom)
            shouldFetchRestOfComments = false
        } else {
            view.updateComments()
            view.updateLoadingCell()
        }
        
    }
    
    private func enableFetchMore() {
        loadMoreCellViewModel.cellHeight = LoadMoreCell.cellHeight
        view.updateLoadingCell()
    }
    
    private func stopLoading() {
        if cursor == nil {
            loadMoreCellViewModel.cellHeight = 0.1
        } else {
            loadMoreCellViewModel.cellHeight = LoadMoreCell.cellHeight
        }
        
        loadMoreCellViewModel.stopLoading()
    }
    
    private func appendWithReplacing(original: inout [Comment], appending: [Comment]) {
        for appendingItem in appending {
            if let index = original.index(where: { $0.commentHandle == appendingItem.commentHandle }) {
                original[index] = appendingItem
            } else {
                original.append(appendingItem)
            }
        }
    }
    
    func didFail(error: Error) {
        loadMoreCellViewModel.cellHeight = 0.1
        loadMoreCellViewModel.stopLoading()
        view.updateLoadingCell()
        view.endRefreshing()
        view.hideLoadingHUD()
    }
    
    func commentDidPost(comment: Comment) {
        comments.append(comment)
        view.postCommentSuccess()
        feedModuleInput?.refreshData()
    }
    
    func commentPostFailed(error: Error) {
        view.hideLoadingHUD()
    }
    
    private func setupFeed() {
        guard let vc = feedViewController else {
            return
        }
        
        _ = vc.view
        feedModuleInput?.refreshData()
        
        view.setFeedViewController(vc)
    }
    
    // MAKR: PostDetailViewOutput
    
    func loadCellModel() -> LoadMoreCellViewModel {
        return loadMoreCellViewModel
    }
    
    func canFetchMore() -> Bool {
        return cursor != nil && !dataIsFetching
    }
    
    func refresh() {
        cursor = nil
        scrollType = .none
        feedModuleInput?.refreshData()
        loadMoreCellViewModel.cellHeight = LoadMoreCell.cellHeight
        loadMoreCellViewModel.startLoading()
        view.updateLoadingCell()
        interactor.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: Int32(pageSize))
    }
    
    func viewIsReady() {
        view.setupInitialState()
        setupFeed()
        interactor.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: Int32(pageSize))
    }
    
    func loadRestComments() {
        if cursor == nil {
            view.reloadTable(scrollType: .bottom)
        } else {
            shouldFetchRestOfComments = true
            fetchMore()
        }
    }
    
    func numberOfItems() -> Int {
        return comments.count
    }
    
    func fetchMore() {
        dataIsFetching = true
        loadMoreCellViewModel.startLoading()
        view.updateLoadingCell()
        interactor.fetchMoreComments(topicHandle: topicHandle, cursor: cursor, limit: Int32(pageSize))
    }
    
    func comment(at index: Int) -> Comment {
        return comments[index]
    }
    
    func postComment(photo: Photo?, comment: String) {
        actionStrategy.executeOrPromptLogin { [weak self] in self?._postComment(photo: photo, comment: comment) }
    }
    
    private func _postComment(photo: Photo?, comment: String) {
        interactor.postComment(photo: photo, topicHandle: topicHandle, comment: comment)
    }
    
}

extension PostDetailPresenter: CommentCellModuleOutout {
    
    func show(menuController: UIViewController) {
        view.showMenu(menuController)
    }
    
    func removed(comment: Comment) {
        assert(Thread.isMainThread)
        
        let handles = comments.flatMap { $0.commentHandle }
        print("*********** [presenter] attempt to delete \(handles)")

        guard let index = comments.index(where: { $0.commentHandle == comment.commentHandle }) else {
            return
        }
        
        print("*********** [presenter] deleted success")
        
        comments.remove(at: index)
        router.backIfNeeded(from: view as! UIViewController)
        view.removeComment(index: index)
        feedModuleInput?.refreshData()
    }
}

extension PostDetailPresenter: Subscriber {
    
    func update(_ hint: Hint) {
        if let hint = hint as? CommentUpdateHint {
            updateCommentHandle(from: hint.oldHandle, to: hint.newHandle)
        } else if let hint = hint as? TopicUpdateHint, canHandle(hint) {
            topicHandle = hint.newHandle
            feedModuleInput?.feedType = .single(post: hint.newHandle)
            feedModuleInput?.refreshData()
        }
    }
    
    private func canHandle(_ hint: TopicUpdateHint) -> Bool {
        if let feedType = feedModuleInput?.feedType,
            case let FeedType.single(topicHandle) = feedType,
            topicHandle == hint.oldHandle {
            return true
        } else {
            return false
        }
    }
    
    private func updateCommentHandle(from oldHandle: String, to newHandle: String) {
        guard let idx = comments.index(where: { $0.commentHandle == oldHandle }) else { return }
        
        print("*********** Update at \(index) from \(oldHandle) to \(newHandle) comment \(comments[idx].text)", idx)

        let commentToUpdate = comments[idx]
        commentToUpdate.commentHandle = newHandle
        comments[idx] = commentToUpdate
    }
}

extension PostDetailPresenter: FeedModuleOutput {

    func didScrollFeed(_ feedView: UIScrollView) {
        print("feed did scroll in PostDetailPresenter")
    }
    
    func didStartRefreshingData() {
        print("didStartRefreshingData in PostDetailPresenter")
    }
    
    func didFinishRefreshingData(_ error: Error?) {
        view.refreshPostCell()
        feedModuleInput?.lockScrolling()
    }
    
    func shouldOpenProfile(for userID: String) -> Bool {
        return true
    }
    
    func commentsPressed() {
        view.scrollCollectionViewToBottom()
    }
    
    func postRemoved() {
        guard let vc = view as? UIViewController else {
            return
        }
        router.backToFeed(from: vc)
    }

}

extension PostDetailPresenter: PostMenuModuleOutput {
    
    func postMenuProcessDidStart() { }
    
    func postMenuProcessDidFinish() { }
    
    func didBlock(user: User) { }
    
    func didUnblock(user: User) { }
    
    func didFollow(user: User) {
        for comment in comments where comment.user?.uid == user.uid {
            comment.userStatus = .accepted
        }
        view.reloadTable(scrollType: .none)
    }
    
    func didUnfollow(user: User) {
        for comment in comments where comment.user?.uid == user.uid {
            comment.userStatus = .empty
        }
        view.reloadTable(scrollType: .none)
    }
    
    func didRemove(comment: Comment) {
        removed(comment: comment)
    }
    
    func didReport(post: PostHandle) {
        Logger.log("Not implemented")
    }
    
    func didRequestFail(error: Error) {
        Logger.log("Reloading feed", error, event: .error)
    }
    
}

