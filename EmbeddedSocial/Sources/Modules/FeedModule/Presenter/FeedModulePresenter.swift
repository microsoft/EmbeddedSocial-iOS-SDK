//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum FeedType {

    enum TimeRange: Int {
        case today, weekly, alltime
    }
    
    enum UserFeedScope: Int {
        case recent, popular
    }
    
    // Shows home feed
    case home
    // Shows recent feed
    case recent
    // Shows users feed
    case user(user: UserHandle, scope: UserFeedScope)
    // Shows popular feed
    case popular(type: TimeRange)
    // Shows single post
    case single(post: PostHandle)
}

extension FeedType: Equatable {
    
    static func ==(_ lhs: FeedType, _ rhs: FeedType) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home):
            return true
        case (.recent, .recent):
            return true
        case let (.user(lefthandle, leftscope), .user(righthandle, rightscope)):
            return lefthandle == righthandle && leftscope == rightscope
        case let (.popular(left), .popular(right)):
            return left == right
        case let (.single(left), .single(right)):
            return left == right
        default:
            return false
        }
    }
}

enum PostCellAction {
    case like, pin, comment, extra
}

struct PostViewModel {
    
    typealias ActionHandler = (PostCellAction, IndexPath) -> Void
    
    var userName: String = ""
    var title: String = ""
    var text: String = ""
    var isLiked: Bool = false
    var isPinned: Bool = false
    var likedBy: String = ""
    var totalLikes: String = ""
    var totalComments: String = ""
    var timeCreated: String = ""
    var userImageUrl: String? = nil
    var postImageUrl: String? = nil
    
    var cellType: String = PostCell.reuseID
    var onAction: ActionHandler?
}

class FeedModulePresenter: FeedModuleInput, FeedModuleViewOutput, FeedModuleInteractorOutput {
    
    weak var view: FeedModuleViewInput!
    var interactor: FeedModuleInteractorInput!
    var router: FeedModuleRouterInput!
    
    private var feedType: FeedType = .home
    private var layout: FeedModuleLayoutType = .list
    private let limit = Int32(3) // Default
    private var items = [Post]()
    private var cursor: String? = nil
   
    func didTapChangeLayout() {
        flip(layout: &layout)
        view.setLayout(type: layout)
    }
    
    // MARK: FeedModuleInput
    
    func setFeed(_ feed: FeedType) {
        feedType = feed
    }
    
    func refreshData() {
        didAskFetchAll()
    }
    
    // MARK: Private
    private lazy var dateFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .abbreviated
        formatter.includesApproximationPhrase = false
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        formatter.allowsFractionalUnits = false
        
        return formatter
    }()
    
    private func flip(layout: inout FeedModuleLayoutType) {
        layout = FeedModuleLayoutType(rawValue: layout.rawValue ^ 1)!
    }
    
    private func viewModel(with post: Post) -> PostViewModel {
        
        var viewModel = PostViewModel()
        viewModel.userName = String(format: "%@ %@", (post.firstName ?? ""), (post.lastName ?? ""))
        viewModel.title = post.title ?? ""
        viewModel.text = post.text ?? ""
        viewModel.likedBy = "" // TODO: uncomfirmed
    
        viewModel.totalLikes = Localizator.localize("likes_count", post.totalLikes)
        viewModel.totalComments = Localizator.localize("comments_count", post.totalComments)
    
        viewModel.timeCreated =  post.createdTime == nil ? "" : dateFormatter.string(from: post.createdTime!, to: Date())!
        viewModel.userImageUrl = post.photoUrl
        viewModel.postImageUrl = post.imageUrl
        
        viewModel.isLiked = post.liked
        viewModel.isPinned = post.pinned
        
        viewModel.cellType = layout.cellType
        viewModel.onAction = { [weak self] action, path in
            self?.handle(action: action, path: path)
        }
        
        return viewModel
    }
    
    // MARK: FeedModuleViewOutput
    func item(for path: IndexPath) -> PostViewModel {
        return viewModel(with: items[path.row])
    }
    
    private func itemIndex(with postHandle:PostHandle) -> Int? {
        return items.index(where: { $0.topicHandle == postHandle } )
    }
    
    private func handle(action: PostCellAction, path: IndexPath) {
        
        let postHandle = items[path.row].topicHandle!
        
        switch action {
        case .comment:
            router.open(route: .comments)
        case .extra:
            router.open(route: .extra)
        case .like:
            
            let status = items[path.row].liked
            let action:PostSocialAction = status ? .like : .unlike
            
            items[path.row].liked = !status
            
            interactor.postAction(post: postHandle, action: action)
            
        case .pin:
            let status = items[path.row].pinned
            let action:PostSocialAction = status ? .pin : .unpin
            
            items[path.row].pinned = !status
            
            interactor.postAction(post: postHandle, action: action)
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func viewIsReady() {
        view.setupInitialState()
        view.setLayout(type: layout)
        
        didAskFetchAll()
    }
    
    func didAskFetchAll() {
        view.setRefreshing(state: true)
        interactor.fetchPosts(limit: limit, feedType: feedType)
    }
    
    func didAskFetchMore() {
        view.setRefreshing(state: true)
        if let cursor = cursor {
            interactor.fetchPostsMore(limit: limit, feedType: feedType, cursor: cursor)
        } else {
            Logger.log(<#T##something: Any...##Any#>)
        }
    }
    
    func didTapItem(path: IndexPath) {
        //        router.open(route: .postDetails)
    }
    
    // MARK: FeedModuleInteractorOutput
    func didFetch(feed: PostsFeed) {
        items = feed.items
        
        view.setRefreshing(state: false)
        view.reload()
    }
    
    func didFetchMore(feed: PostsFeed) {
        items.append(contentsOf: feed.items)

        view.setRefreshing(state: false)
        view.reload()
    }
    
    func didFail(error: FeedServiceError) {
        Logger.log(error)
    }
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        Logger.log(error)
    }
}
