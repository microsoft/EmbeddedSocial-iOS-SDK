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
    private let maxLimit: Int32 = 30000
    private var shouldFetchRestOfComments = false
    
    fileprivate var dataIsFetching = false
    
    func heightForFeed() -> CGFloat {
        return (feedModuleInput?.moduleHeight())!
    }
    
    // MARK: PostDetailInteractorOutput
    func didFetch(comments: [Comment], cursor: String?) {
        self.cursor = cursor
        self.comments = comments
        view.reloadTable(scrollType: scrollType)
        
        scrollType = .none
    }
    
    func didFetchMore(comments: [Comment], cursor: String?) {
        dataIsFetching = false
        appendWithReplacing(original: &self.comments, appending: comments)
        self.cursor = cursor
        
        if cursor != nil && shouldFetchRestOfComments == true {
            self.fetchMore()
        } else if shouldFetchRestOfComments == true {
            view.reloadTable(scrollType: .bottom)
            shouldFetchRestOfComments = false
        } else {
            view.updateComments()
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
    
    func enableFetchMore() -> Bool {
        return cursor != nil && !dataIsFetching
    }
    
    func refresh() {
        cursor = nil
        interactor.fetchComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: Int32(Constants.PostDetails.pageSize))
    }
    
    func viewIsReady() {
        view.setupInitialState()
        setupFeed()
        switch scrollType {
            case .bottom:
                interactor.fetchComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: maxLimit)
            default:
                interactor.fetchComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: Int32(Constants.PostDetails.pageSize))
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
            interactor.fetchMoreComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: Int32(Constants.PostDetails.pageSize))
        }
        
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
}

