//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol FeedModuleInput: class {
    
    // For feed change
    func setFeed(_ feed: FeedType)
    // Forcing module to update
    // Triggers callbacks for start/finish
    func refreshData()
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type,
                        size: CGSize,
                        configurator: @escaping (T) -> Void)
    // Get Current Module Height
    func moduleHeight() -> CGFloat
    // Change layout
    var layout: FeedModuleLayoutType { get set }
}

protocol FeedModuleOutput: class {
    func didScrollFeed(_ feedView: UIScrollView)
    
    func didStartRefreshingData()
    func didFinishRefreshingData(_ error: Error?)
    
    func shouldOpenProfile(for userID: String) -> Bool
}

//MARK: Optional methods
extension FeedModuleOutput {
    func didScrollFeed(_ feedView: UIScrollView) { }
    
    func didStartRefreshingData() { }
    func didFinishRefreshingData() { }
    
    func shouldOpenProfile(for userID: String) -> Bool { return true }
}

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
    case like, pin, comment, extra, profile, photo
}

struct PostViewModel {
    
    typealias ActionHandler = (PostCellAction, IndexPath) -> Void
    
    var topicHandle: String = ""
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
    
    var tag: Int = 0
    var cellType: String = PostCell.reuseID
    var onAction: ActionHandler?
}

enum FeedModuleLayoutType: Int {
    case list
    case grid
    
    var cellType:String {
        
        switch self {
        case .list:
            return PostCell.reuseID
        case .grid:
            return PostCellCompact.reuseID
        }
    }
    
    var nextLayoutAsset: Asset {
        switch self {
        case .list:
            return .iconGallery
        case .grid:
            return .iconList
        }
    }
    
    var flipped: FeedModuleLayoutType {
        return FeedModuleLayoutType(rawValue: rawValue ^ 1)!
    }
    
    mutating func flip() {
        self = flipped
    }
}

class FeedModulePresenter: FeedModuleInput, FeedModuleViewOutput, FeedModuleInteractorOutput {
    
    weak var view: FeedModuleViewInput!
    var interactor: FeedModuleInteractorInput!
    var router: FeedModuleRouterInput!
    
    weak var moduleOutput: FeedModuleOutput?
    weak var userHolder: UserHolder?
    
    weak var commentsPresenter: SharedPostDetailPresenterProtocol?
    
    var layout: FeedModuleLayoutType = .list {
        didSet {
            view.setLayout(type: self.layout)
        }
    }
    
    fileprivate var feedType: FeedType? {
        didSet {
            Logger.log(feedType)
        }
    }
    
    fileprivate var cursor: String? = nil {
        didSet {
            Logger.log(cursor)
        }
    }
    
    private var formatter = DateFormatterTool()
    private let limit = Int32(Constants.Feed.pageSize) // Default
    fileprivate var items = [Post]()
    fileprivate var header: SupplementaryItemModel?
    
    var headerSize: CGSize {
        return header?.size ?? .zero
    }
    
    func didTapChangeLayout() {
        layout = layout.flipped
        view.setLayout(type: layout)
    }
    
    // MARK: FeedModuleInput
    
    func moduleHeight() -> CGFloat {
        return view.getViewHeight()
    }
    
    func setFeed(_ feed: FeedType) {
        feedType = feed
        cleanFeed()
    }
    
    func refreshData() {
        
        guard let feedType = self.feedType else {
            Logger.log("feed type is not set")
            return
        }
        
        Logger.log()
        interactor.fetchPosts(limit: limit, cursor: nil, feedType: feedType)
    }
    
    // MARK: Private
    
    fileprivate func isHome() -> Bool {
        return feedType == .home
    }
    
    private func cleanFeed() {
        cursor = nil
        items.removeAll()
    }
    
    private func viewModel(with post: Post) -> PostViewModel {
        
        var viewModel = PostViewModel()
        viewModel.topicHandle = post.topicHandle
        viewModel.userName = String(format: "%@ %@", (post.firstName ?? ""), (post.lastName ?? ""))
        viewModel.title = post.title ?? ""
        viewModel.text = post.text ?? ""
        viewModel.likedBy = "" // TODO: uncomfirmed
        
        viewModel.totalLikes = L10n.Post.likesCount(post.totalLikes)
        viewModel.totalComments = L10n.Post.commentsCount(post.totalComments)
        
        viewModel.timeCreated =  post.createdTime == nil ? "" : formatter.shortStyle.string(from: post.createdTime!, to: Date())!
        viewModel.userImageUrl = post.photoUrl
        viewModel.postImageUrl = post.imageUrl
        
        viewModel.isLiked = post.liked
        viewModel.isPinned = post.pinned
        
        viewModel.tag = items.index(of: post) ?? 0
        viewModel.cellType = layout.cellType
        viewModel.onAction = { [weak self] action, path in
            self?.handle(action: action, path: path)
        }
        
        return viewModel
    }
    
    private func appendWithReplacing(original: inout [Post], appending: [Post]) {
        
        for appendingItem in appending {
            
            if let index = original.index(where: { $0.topicHandle == appendingItem.topicHandle }) {
                original[index] = appendingItem
            } else {
                original.append(appendingItem)
            }
        }
    }
    
    // MARK: FeedModuleViewOutput
    func item(for path: IndexPath) -> PostViewModel {
        return viewModel(with: items[path.row])
    }
    
    private func itemIndex(with postHandle:PostHandle) -> Int? {
        return items.index(where: { $0.topicHandle == postHandle } )
    }
    
    private func handle(action: PostCellAction, path: IndexPath) {
        
        let index = path.row
        let postHandle = items[index].topicHandle!
        let userHandle = items[index].userHandle!
        let post = items[index]
        
        switch action {
        case .comment:
            router.open(route: .comments(post: viewModel(with: post)), presenter: self)
        case .extra:
            
            let isMyPost = (userHolder?.me?.uid == userHandle)
            
            if isMyPost {
                router.open(route: .myPost(post: post), feedSource: feedType!)
            } else {
                router.open(route: .othersPost(post: post), feedSource: feedType!)
            }
        case .like:
            
            let status = items[index].liked
            let action:PostSocialAction = status ? .unlike : .like
            
            items[index].liked = !status
            
            if action == .like {
                items[index].totalLikes += 1
            } else if action == .unlike && items[index].totalLikes > 0 {
                items[index].totalLikes -= 1
            }
            
            view.reload(with: index)
            commentsPresenter?.refresh(post: viewModel(with: items[index]))
            interactor.postAction(post: postHandle, action: action)
            
        case .pin:
            let status = items[index].pinned
            let action:PostSocialAction = status ? .unpin : .pin
            
            items[index].pinned = !status
            
            view.reload(with: index)
            interactor.postAction(post: postHandle, action: action)
            
        case .profile:
            guard moduleOutput?.shouldOpenProfile(for: userHandle) ?? true else { return }
            
            let isMyProfile = userHolder?.me?.uid == userHandle
            
            if isMyProfile {
                router.open(route: .myProfile, feedSource: feedType!)
            } else {
                router.open(route: .profileDetailes(user: userHandle), feedSource: feedType!)
            }
            
        case .photo:
            guard let imageUrl = items[path.row].imageUrl else {
                return
            }
            
            router.open(route: .openImage(image: imageUrl), feedSource: feedType!)
        }
        
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func viewIsReady() {
        view.setupInitialState()
        view.setLayout(type: layout)
        if let header = header {
            view.registerHeader(withType: header.type, configurator: header.configurator)
        }
        
        didAskFetchAll()
    }
    
    func viewDidAppear() {
        
        //        if isHome() {
        didAskFetchAll()
        //        }
    }
    
    func didAskFetchAll() {
    
        guard let feedType = self.feedType else {
            Logger.log("feed type is not set")
            return
        }
        
        interactor.fetchPosts(limit: limit, cursor: nil, feedType: feedType)
    }
    
    func didAskFetchMore() {
        
        guard let feedType = self.feedType else {
            Logger.log("feed type is not set")
            return
        }
        
        guard let cursor = cursor else {
            Logger.log("cant fetch more, no cursor")
            return
        }
        
        Logger.log(cursor)
        interactor.fetchPosts(limit: limit, cursor: cursor, feedType: feedType)
    }
    
    func didTapItem(path: IndexPath) {
        Logger.log(path)
        router.open(route: .postDetails(post: viewModel(with: items[path.row])), presenter: self)
    }
    
    // MARK: FeedModuleInteractorOutput
    func didFetch(feed: PostsFeed) {
        
        guard feedType == feed.feedType else {
            return
        }
        
        cursor = feed.cursor
        items = feed.items
        
        view.reload()
    }
    
    func didFetchMore(feed: PostsFeed) {
        
        guard feedType == feed.feedType else {
            return
        }
        
        cursor = feed.cursor
        appendWithReplacing(original: &items, appending: feed.items)
        
        view.reload()
    }
    
    func didFail(error: FeedServiceError) {
        view.showError(error: error)
    }
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        Logger.log(action, post, error)
    }
    
    func didStartFetching() {
        Logger.log()
        view.setRefreshing(state: true)
        if let delegate = moduleOutput {
            delegate.didStartRefreshingData()
        } else {
            view.setRefreshingWithBlocking(state: true)
        }
    }
    
    func didFinishFetching() {
        Logger.log()
        view.setRefreshing(state: false)
        if let delegate = moduleOutput {
            delegate.didFinishRefreshingData(nil)
        } else {
            view.setRefreshingWithBlocking(state: false)
        }
    }
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type,
                        size: CGSize,
                        configurator: @escaping (T) -> Void) {
        header = SupplementaryItemModel(type: type, size: size, configurator: { view in
            guard let view = view as? T else {
                fatalError("Unregistered header view")
            }
            configurator(view)
        })
    }
    
    func configureHeader(_ headerView: UICollectionReusableView) {
        header?.configurator(headerView)
    }
    
    func didScrollFeed(_ feedView: UIScrollView) {
        moduleOutput?.didScrollFeed(feedView)
    }
    
    deinit {
        Logger.log()
    }
}

extension FeedModulePresenter {
    struct SupplementaryItemModel {
        let type: UICollectionReusableView.Type
        let size: CGSize
        let configurator: (UICollectionReusableView) -> Void
    }
}

extension FeedModulePresenter: PostMenuModuleOutput {
    
    func postMenuProcessDidStart() {
        view.setRefreshingWithBlocking(state: true)
    }
    
    func postMenuProcessDidFinish() {
        view.setRefreshingWithBlocking(state: false)
    }
    
    func didBlock(user: UserHandle) {
        Logger.log("Success")
    }
    
    func didUnblock(user: UserHandle) {
        Logger.log("Success")
    }
    
    func didFollow(user: UserHandle) {
        
        if isHome() {
            
            // Refetch Data
            didAskFetchAll()
            
        } else {
            
            // Update following status for current posts
            for (index, item) in items.enumerated() {
                if item.userHandle == user {
                    items[index].userStatus = .follow
                }
            }
            
            view.reloadVisible()
        }
    }
    
    func didUnfollow(user: UserHandle) {
       
        if isHome() {
            
            // Refetch Data
            didAskFetchAll()
            
        } else {
            
            // Update following status for current posts
            for (index, item) in items.enumerated() {
                if item.userHandle == user && item.userStatus == .follow {
                    items[index].userStatus = .none
                }
            }
            
            view.reloadVisible()
        }
    }
    
    func didHide(post: PostHandle) {
        didRemoveItem(post: post)
    }
    
    func didEdit(post: PostHandle) {
        didChangeItem(post: post)
    }
    
    func didRemove(post: PostHandle) {
        didRemoveItem(post: post)
    }
    
    func didReport(post: PostHandle) {
        Logger.log("Not implemented")
    }
    
    func didRequestFail(error: Error) {
        Logger.log("Reloading feed", error, event: .error)
        view.showError(error: error)
        didAskFetchAll()
    }
    
    // MARK: Private
    
    private func didChangeItem(user: UserHandle) {
        if let index = items.index(where: { $0.userHandle == user }) {
            view.reload(with: index)
        }
    }
    
    private func didChangeItem(post: PostHandle) {
        if let index = items.index(where: { $0.topicHandle == post }) {
            view.reload(with: index)
        }
    }
    
    private func didRemoveItem(post: PostHandle) {
        if let index = items.index(where: { $0.topicHandle == post }) {
            items.remove(at: index)
            view.removeItem(index: index)
        }
    }
    
    private func didFail(_ error: Error) {
        view.showError(error: error)
    }
}

