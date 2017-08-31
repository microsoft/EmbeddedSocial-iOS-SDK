//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol SharedPostDetailPresenterProtocol: class {
    func refresh(post: PostViewModel)
}

class PostDetailPresenter: PostDetailViewOutput, PostDetailInteractorOutput, SharedPostDetailPresenterProtocol {
    
    weak var view: PostDetailViewInput!
    var interactor: PostDetailInteractorInput!
    var router: PostDetailRouterInput!
    var scrollType: CommentsScrollType = .none
    
    var repliesPresenter: SharedCommentsPresenterProtocol?
    
    var postViewModel: PostViewModel?
    weak var postViewModelActionsHandler: PostViewModelActionsProtocol!
    
    var feedViewController: UIViewController?
    var feedModuleInput: FeedModuleInput?

    var comments = [Comment]()
    
    private var formatter = DateFormatterTool()
    private var cursor: String?
    private let normalLimit: Int32 = 50
    private let maxLimit: Int32 = 10000
    private var shouldFetchRestOfComments = false
    
    
    private func viewModel(with comment: Comment) -> CommentViewModel {
        
        var viewModel = CommentViewModel()
        viewModel.comment = comment
        viewModel.commentHandle = comment.commentHandle
        viewModel.userName = String(format: "%@ %@", (comment.firstName ?? ""), (comment.lastName ?? ""))
        viewModel.text = comment.text ?? ""
        
        viewModel.totalLikes = L10n.Post.likesCount(Int(comment.totalLikes))
        viewModel.totalReplies = L10n.Post.repliesCount(Int(comment.totalReplies))
        
        viewModel.timeCreated =  comment.createdTime == nil ? "" : formatter.shortStyle.string(from: comment.createdTime!, to: Date())!
        viewModel.userImageUrl = comment.photoUrl
        viewModel.commentImageUrl = comment.mediaUrl
        
        viewModel.isLiked = comment.liked
        viewModel.tag = comments.index(of: comment) ?? 0
        
        viewModel.cellType = CommentCell.reuseID
        viewModel.onAction = { [weak self] action, index in
            self?.handle(action: action, index: index)
        }
        
        return viewModel
    }
    
    func handle(action: CommentCellAction, index: Int) {
        
        let commentHandle = comments[index].commentHandle
        let userHandle = comments[index].userHandle!
        
        switch action {
        case .replies:
            router.openReplies(commentView: viewModel(with:  comments[index]), scrollType: .bottom, from: view as! UIViewController, postDetailPresenter: self)
        case .like:
            
            let status = comments[index].liked
            let action: CommentSocialAction = status ? .unlike : .like
            
            comments[index].liked = !status
            
            if action == .like {
                comments[index].totalLikes += 1
            } else if action == .unlike && comments[index].totalLikes > 0 {
                comments[index].totalLikes -= 1
            }
            
            view.refreshCell(index: index)
            repliesPresenter?.refreshCommentCell(commentView: viewModel(with: comments[index]))
            interactor.commentAction(commentHandle: commentHandle!, action: action)
            
        case .profile:
            router.openUser(userHandle: userHandle, from: view as! UIViewController)
            
        case .photo:
            guard let imageUrl = comments[index].mediaUrl else {
                return
            }

            router.openImage(imageUrl: imageUrl, from: view as! UIViewController)
        }
        
    }
    
    // MARK: SharedPostDetailPresenterProtocol
    func refresh(post: PostViewModel) {
        self.postViewModel = post
        view.refreshPostCell()
    }
    
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
        self.cursor = cursor
        appendWithReplacing(original: &self.comments, appending: comments)
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
    
    func didPostAction(commentHandle: String, action: CommentSocialAction, error: Error?) {
        
        guard let index = comments.enumerated().first(where: { $0.element.commentHandle == commentHandle })?.offset else {
            return
        }
        
        view.refreshCell(index: index)
    }
    
    func postFetched(post: Post) {
        postViewModel?.config(with: post, index: self.postViewModel?.tag, cellType: self.postViewModel?.cellType, actionHandler: postViewModelActionsHandler)
        view.refreshPostCell()
    }
    
    private func setupFeed() {
        guard let vc = feedViewController else {
            return
        }
        
        view.setFeedViewController(vc)
    }
    
    // MAKR: PostDetailViewOutput
    
    func refreshPost() {
        interactor.loadPost(topicHandle: (postViewModel?.topicHandle)!)
    }
    
    func openReplies(index: Int) {
        router.openReplies(commentView: viewModel(with:  comments[index]), scrollType: .none, from: view as! UIViewController, postDetailPresenter: self)
    }
    
    func enableFetchMore() -> Bool {
        return cursor != nil
    }
    
    func openUser(index: Int) {
        guard let userHandle =  comments[index].userHandle else {
            return
        }
        
        router.openUser(userHandle: userHandle, from: view as! UIViewController)
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
        if shouldFetchRestOfComments {
            interactor.fetchMoreComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: maxLimit)
        } else {
            interactor.fetchMoreComments(topicHandle: (postViewModel?.topicHandle)!, cursor: cursor, limit: normalLimit)
        }
        
    }
    
    func commentViewModel(index: Int) -> CommentViewModel {
        return viewModel(with: comments[index])
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
        
    }
    
    func didStartRefreshingData() {
        
    }
    
    func didFinishRefreshingData(_ error: Error?) {
        
    }
    
    func shouldOpenProfile(for userID: String) -> Bool {
        return true
    }
}

