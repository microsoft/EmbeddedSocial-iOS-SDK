//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class PostDetailPresenter: PostDetailViewOutput, PostDetailInteractorOutput, PostDetailModuleInput {

    weak var view: PostDetailViewInput!
    var interactor: PostDetailInteractorInput!
    var router: PostDetailRouterInput!
    var scrollType: CommentsScrollType = .none
    
    var postViewModel: PostViewModel?
    
    var feedViewController: UIViewController?
    var feedModuleInput: FeedModuleInput?

    var comments = [Comment]()
    
    private var formatter = DateFormatterTool()
    private var cursor: String?
    private var shouldFetchRestOfComments = false
    
    fileprivate var dataIsFetching = false
    fileprivate var loadMoreCellViewModel = LoadMoreCellViewModel()
    
    var myProfileHolder: UserHolder!

    
    func heightForFeed() -> CGFloat {
        return (feedModuleInput?.moduleHeight())!
    }
    

    init(myProfileHolder: UserHolder) {
        self.myProfileHolder = myProfileHolder
    }
    
    func commentRemoved(comment: Comment) {
        guard let index = comments.index(where: { $0.commentHandle == comment.commentHandle }) else {
            return
        }
        
        comments.remove(at: index)
        router.backIfNeeded(from: view as! UIViewController)
        view.removeComment(index: index)
        feedModuleInput?.refreshData()
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
    
    private func stopLoading() {
        if cursor == nil {
            loadMoreCellViewModel.cellHeight = 0.1
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
    
    func didFail(error: CommentsServiceError) {
    }
    
    func commentDidPost(comment: Comment) {
        comments.append(comment)
        view.postCommentSuccess()
        feedModuleInput?.refreshData()
    }
    
    func commentPostFailed(error: Error) {
        
    }
    
    private func setupFeed() {
        feedModuleInput?.refreshData()
        guard let vc = feedViewController else {
            return
        }
        
        view.setFeedViewController(vc)
    }
    
    // MAKR: PostDetailViewOutput
    
    func loadCellModel() -> LoadMoreCellViewModel {
        return loadMoreCellViewModel
    }
    
    func enableFetchMore() -> Bool {
        return cursor != nil && !dataIsFetching
    }
    
    func refresh() {
        cursor = nil
        scrollType = .none
        loadMoreCellViewModel.cellHeight = LoadMoreCell.cellHeight
        loadMoreCellViewModel.startLoading()
        view.updateLoadingCell()
        interactor.fetchComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: Int32(Constants.PostDetails.pageSize))
    }
    
    func viewIsReady() {
        view.setupInitialState()
        setupFeed()
        interactor.fetchComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: Int32(Constants.PostDetails.pageSize))
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
        interactor.fetchMoreComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: Int32(Constants.PostDetails.pageSize))
    }
    
    func comment(at index: Int) -> Comment {
        return comments[index]
    }
    
    func postComment(photo: Photo?, comment: String) {
        guard myProfileHolder.me != nil else {
            router.openLogin(from: view as! UIViewController)
            return
        }
        view.showHUD()
        interactor.postComment(photo: photo, topicHandle: (postViewModel?.topicHandle)!, comment: comment)
    }
}

extension PostDetailPresenter: FeedModuleOutput {
    func didFinishRefreshingData() {
        view.refreshPostCell()
    }
    
    func didScrollFeed(_ feedView: UIScrollView) {
        print("feed did scroll in PostDetailPresenter")
    }
    
    func didStartRefreshingData() {
        print("didStartRefreshingData in PostDetailPresenter")
    }
    
    func didFinishRefreshingData(_ error: Error?) {
        view.refreshPostCell()
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

