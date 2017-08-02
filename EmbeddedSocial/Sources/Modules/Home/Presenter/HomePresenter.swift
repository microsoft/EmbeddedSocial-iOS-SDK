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

class HomePresenter: HomeModuleInput, HomeViewOutput, HomeInteractorOutput {
    
    weak var view: HomeViewInput!
    var interactor: HomeInteractorInput!
    var router: HomeRouterInput!
    
    private var configuration: FeedType = .home
    private var layout: HomeLayoutType = .list
    private let limit = Int32(3) // Default
    private var items = [Post]()
   
    func didTapChangeLayout() {
        flip(layout: &layout)
        view.setLayout(type: layout)
    }
    
    // MARK: HomeModuleInput
    
    func setFeed(_ feed: FeedType) {
        configuration = feed
    }
    
    // MARK: Private
    
    private func didRequestFeed() {
        
//        switch configuration {
//        case .home:
//            interactor.fetchPosts(with: limit)
//        case .recent:
//            interactor.fetchPosts(with: limit)
//        case .popular(let type = Feed.PopularType.alltime)
//            interactor.fe
//        }
        
        
    }
    
    private lazy var dateFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .abbreviated
        formatter.includesApproximationPhrase = false
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        formatter.allowsFractionalUnits = false
        
        return formatter
    }()
    
    private func flip(layout: inout HomeLayoutType) {
        layout = HomeLayoutType(rawValue: layout.rawValue ^ 1)!
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
        
        viewModel.isLiked = post.liked ?? false
        viewModel.isPinned = post.pinned ?? false
        
        viewModel.cellType = layout.cellType
        viewModel.onAction = { [weak self] action, path in
            self?.handle(action: action, path: path)
        }
        
        return viewModel
    }
    
    // MARK: HomeViewOutput
    func item(for path: IndexPath) -> PostViewModel {
        return viewModel(with: items[path.row])
    }
    
    private func itemIndex(with postHandle:PostHandle) -> Int? {
        return items.index(where: { $0.topicHandle == postHandle } )
    }
    
    private func handle(action: PostCellAction, path: IndexPath) {
        switch action {
        case .comment:
            didTapComment(with: path)
        case .extra:
            didTapExtra(with: path)
        case .like:
            didTapLike(with: path)
        case .pin:
            didTapPin(with: path)
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func viewIsReady() {
        view.setupInitialState()
        view.setLayout(type: layout)
        
        didPullRefresh()
    }
    
    func didPullRefresh() {
        view.setRefreshing(state: true)
        interactor.fetchPosts(limit: limit, type: configuration)
    }
    
    func didTapItem(path: IndexPath) {
//        router.open(route: .postDetails)
    }
    
    // MARK: HomeInteractorOutput
    func didFetch(feed: PostsFeed) {
        items = feed.items
        
        view.setRefreshing(state: false)
        view.reload()
    }
    
    func didFetchMore(feed: PostsFeed) {
        items.insert(contentsOf:feed.items, at: 0)

        view.setRefreshing(state: false)
        view.reload()
    }
    
    func didFail(error: FeedServiceError) {
        Logger.log(error)
    }
    
    func didUnpin(post id: PostHandle) {
        if let index = itemIndex(with: id) {
            items[index].pinned = false
            view.reload(with: index)
        }
    }
    
    func didUnlike(post id: PostHandle) {
        if let index = itemIndex(with: id) {
            items[index].liked = false
            
            if (items[index].totalLikes > 0) {
                items[index].totalLikes -= Int64(1)
            }
            view.reload(with: index)
        }
    }
    
    func didLike(post id: PostHandle) {
        if let index = itemIndex(with: id) {
            items[index].liked = true
            items[index].totalLikes += Int64(1)
            view.reload(with: index)
        }
    }
    
    func didPin(post id: PostHandle) {
        if let index = itemIndex(with: id) {
            items[index].pinned = true
            view.reload(with: index)
        }
    }
    
    private func didTapComment(with path: IndexPath) {
        router.open(route: .comments)
    }
    
    private func didTapExtra(with path: IndexPath) {
        router.open(route: .extra)
    }
    
    private func didTapLike(with path: IndexPath) {
        let item = items[path.row]
        
        if item.liked {
            interactor.unlike(with: item.topicHandle)
        } else {
            interactor.like(with: item.topicHandle)
        }
    }
    
    private func didTapPin(with path: IndexPath) {
        let item = items[path.row]
        
        if item.pinned {
            interactor.unpin(with: item.topicHandle)
        } else {
            interactor.pin(with: item.topicHandle)
        }
    }
}
