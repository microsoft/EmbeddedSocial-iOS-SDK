//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum CommentCellAction {
    case like, replies, profile, photo
}

struct CommentViewModel {
    
    typealias ActionHandler = (CommentCellAction, Int) -> Void
    
    var userName: String = ""
    var title: String = ""
    var text: String = ""
    var isLiked: Bool = false
    var totalLikes: String = ""
    var totalReplies: String = ""
    var timeCreated: String = ""
    var userImageUrl: String? = nil
    var commentImageUrl: String? = nil
    
    var cellType: String = CommentCell.reuseID
    var onAction: ActionHandler?
}

class PostDetailPresenter: PostDetailModuleInput, PostDetailViewOutput, PostDetailInteractorOutput {
    
    weak var view: PostDetailViewInput!
    var interactor: PostDetailInteractorInput!
    var router: PostDetailRouterInput!
    var scrollType: CommentsScrollType = .none
    
    var feedViewController: UIViewController?
    var feedModuleInput: FeedModuleInput?
    
    var post: Post?

    var comments = [Comment]()
    
    private var formatter = DateFormatterTool()
    private var cursor: String?
    private let normalLimit: Int32 = 50
    private let maxLimit: Int32 = 10000
    private var shouldFetchRestOfComments = false
    
    
    private func viewModel(with comment: Comment) -> CommentViewModel {
        
        var viewModel = CommentViewModel()
        viewModel.userName = String(format: "%@ %@", (comment.firstName ?? ""), (comment.lastName ?? ""))
        viewModel.text = comment.text ?? ""
        
        viewModel.totalLikes = L10n.Post.likesCount(Int(comment.totalLikes))
        viewModel.totalReplies = L10n.Post.repliesCount(Int(comment.totalReplies))
        
        viewModel.timeCreated =  comment.createdTime == nil ? "" : formatter.shortStyle.string(from: comment.createdTime!, to: Date())!
        viewModel.userImageUrl = comment.photoUrl
        viewModel.commentImageUrl = comment.mediaUrl
        
        viewModel.isLiked = comment.liked
        
        viewModel.cellType = CommentCell.reuseID
        viewModel.onAction = { [weak self] action, index in
            self?.handle(action: action, index: index)
        }
        
        return viewModel
    }
    
    private func handle(action: CommentCellAction, index: Int) {
        
        let commentHandle = comments[index].commentHandle!
        let userHandle = comments[index].userHandle!
        
        switch action {
        case .replies: break
        //            router.open(route: .comments, feedSource: feedType!)
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
            interactor.commentAction(commentHandle: commentHandle, action: action)
            
            
        case .profile:
            router.openUser(userHandle: userHandle, from: view as! UIViewController)
            
        case .photo:
            guard let imageUrl = comments[index].mediaUrl else {
                return
            }

            router.openImage(imageUrl: imageUrl, from: view as! UIViewController)
        }
        
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
        self.comments.append(contentsOf: comments)
        if cursor != nil && shouldFetchRestOfComments == true {
            self.fetchMore()
        } else if shouldFetchRestOfComments == true {
            view.reloadTable(scrollType: .bottom)
            shouldFetchRestOfComments = false
        } else {
            view.reloadTable(scrollType: .none)
        }
        
    }
    
    func didFail(error: CommentsServiceError) {
    }
    
    func commentDidPosted(comment: Comment) {
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
    
    // MAKR: PostDetailViewOutput
    
    func openUser(index: Int) {
        guard let userHandle =  comments[index].userHandle else {
            return
        }
        
        router.openUser(userHandle: userHandle, from: view as! UIViewController)
    }
    
    func refresh() {
        interactor.fetchComments(topicHandle: (post?.topicHandle)!, cursor: cursor, limit: normalLimit)
    }
    
    func feedModuleHeight() -> CGFloat {
        guard let moduleHeight = feedModuleInput?.moduleHeight() else {
            return 0
        }
        
        return moduleHeight
    }
    
    func viewIsReady() {
        view.setupInitialState()
        setupFeed()
        switch scrollType {
            case .bottom:
                interactor.fetchComments(topicHandle: (post?.topicHandle)!, cursor: cursor, limit: maxLimit)
            default:
                interactor.fetchComments(topicHandle: (post?.topicHandle)!, cursor: cursor, limit: normalLimit)
        }
    }
    
    private func setupFeed() {
        feedModuleInput?.setFeed(.single(post: (post?.topicHandle)!))
        feedModuleInput?.refreshData()
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
            interactor.fetchMoreComments(topicHandle: (post?.topicHandle)!, cursor: cursor, limit: maxLimit)
        } else {
            interactor.fetchMoreComments(topicHandle: (post?.topicHandle)!, cursor: cursor, limit: normalLimit)
        }
        
    }
    
    func commentViewModel(index: Int) -> CommentViewModel {
        return viewModel(with: comments[index])
    }
    
    func postComment(photo: Photo?, comment: String) {
        interactor.postComment(photo: photo, topicHandle: (post?.topicHandle)!, comment: comment)
    }
}

extension PostDetailPresenter: FeedModuleOutput {
    
    func didRefreshData() {
        view.updateFeed(view: (feedViewController?.view)!, scrollType: scrollType)
    }
    
    func didFailToRefreshData(_ error: Error) {
//        view.setFilterEnabled(true)
    }
}
