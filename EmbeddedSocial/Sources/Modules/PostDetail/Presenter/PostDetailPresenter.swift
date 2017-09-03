//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class PostDetailPresenter: PostDetailViewOutput, PostDetailInteractorOutput {

    
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
    private let normalLimit: Int32 = 10
    private let maxLimit: Int32 = 10000
    private var shouldFetchRestOfComments = false
    
    fileprivate var lastFetchedItemsCount = 0
    fileprivate var dataIsFetching = false
    
    
    func heightForFeed() -> CGFloat {
        return (feedModuleInput?.moduleHeight())!
    }
    
    func newItemsCount() -> Int {
        return lastFetchedItemsCount
    }
    
    // MARK: PostDetailInteractorOutput
    func didFetch(comments: [Comment], cursor: String?) {
        self.lastFetchedItemsCount = comments.count
        self.cursor = cursor
        self.comments = comments
        view.reloadTable(scrollType: scrollType)
        
        scrollType = .none
    }
    
    func didFetchMore(comments: [Comment], cursor: String?) {
        dataIsFetching = false
        self.lastFetchedItemsCount = comments.count
        appendWithReplacing(original: &self.comments, appending: comments)
        self.cursor = cursor
        view.updateReplies()
        return
        
        self.cursor = cursor
        
        if cursor != nil && shouldFetchRestOfComments == true {
            self.fetchMore()
        } else if shouldFetchRestOfComments == true {
            view.reloadTable(scrollType: .bottom)
            shouldFetchRestOfComments = false
        } else {
            view.reloadTable(scrollType: .none)
        }
        
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
    }
    
    func commentPostFailed(error: Error) {
        
    }
    
    private func setupFeed() {
        guard let vc = feedViewController else {
            return
        }
        
        view.setFeedViewController(vc)
    }
    
    // MAKR: PostDetailViewOutput
    
    
    func enableFetchMore() -> Bool {
        return cursor != nil && !dataIsFetching
    }
    
    func refresh() {
        interactor.fetchComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: normalLimit)
    }
    
    func viewIsReady() {
        view.setupInitialState()
        setupFeed()
        switch scrollType {
            case .bottom:
                interactor.fetchComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: maxLimit)
            default:
                interactor.fetchComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: normalLimit)
        }
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
        if shouldFetchRestOfComments {
            interactor.fetchMoreComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: maxLimit)
        } else {
            interactor.fetchMoreComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: normalLimit)
        }
        
    }
    
    func comment(at index: Int) -> Comment {
        return comments[index]
    }
    
    func postComment(photo: Photo?, comment: String) {
        interactor.postComment(photo: photo, topicHandle: (postViewModel?.topicHandle)!, comment: comment)
    }
}

extension PostDetailPresenter: FeedModuleOutput {
    func didFinishRefreshingData() {
        print("refresed")
    }
    
    func didScrollFeed(_ feedView: UIScrollView) {
        print("did scroll")
    }
    
    func didStartRefreshingData() {
        print("didStartRefreshingData")
    }
    
    func didFinishRefreshingData(_ error: Error?) {
        view.refreshPostCell()
    }
    
    func shouldOpenProfile(for userID: String) -> Bool {
        return true
    }
}

