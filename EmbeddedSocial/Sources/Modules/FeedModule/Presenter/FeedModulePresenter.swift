//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol FeedModuleInput: class {

    // Forces module to fetch all feed
    func refreshData()
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type,
                        size: CGSize,
                        configurator: @escaping (T) -> Void)
    
    func setHeaderHeight(_ height: CGFloat)
    
    // Get Current Module Height
    func moduleHeight() -> CGFloat
    // Layout
    var layout: FeedModuleLayoutType { get set }
    // Changing feedType triggers items refetching and view reload
    var feedType: FeedType? { get set }
}

protocol FeedModuleOutput: class {
    func didScrollFeed(_ feedView: UIScrollView)
    
    func didStartRefreshingData()
    func didFinishRefreshingData(_ error: Error?)
    
    func shouldOpenProfile(for userID: String) -> Bool
}

extension FeedModuleOutput {
    func didScrollFeed(_ feedView: UIScrollView) { }
    
    func didStartRefreshingData() { }
    func didFinishRefreshingData(_ error: Error?) { }
    
    func shouldOpenProfile(for userID: String) -> Bool {
        return false
    }
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
    // Show my pinned posts
    case myPins
    // Shows recent feed
    case recent
    // Shows users feed
    case user(user: UserHandle, scope: UserFeedScope)
    // Shows popular feed
    case popular(type: TimeRange)
    // Shows single post
    case single(post: PostHandle)
    // Shows search feed
    case search(query: String?)
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
        case let (.search(left), .search(right)):
            return left == right
        case (.myPins, .myPins):
            return true
        default:
            return false
        }
    }
}

enum FeedPostCellAction: Int {
    case like, pin, comment, extra, profile, photo, likesList
    
    var requiresAuthorization: Bool {
        switch self {
        case .like, .pin:
            return true
        default:
            return false
        }
    }
}

extension FeedPostCellAction {
    static let allCases: [FeedPostCellAction] = [.like, .pin, .comment, .extra, .profile, .photo, .likesList]
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

class FeedModulePresenter: FeedModuleInput, FeedModuleViewOutput, FeedModuleInteractorOutput, PostViewModelActionsProtocol {
    
    weak var view: FeedModuleViewInput!
    var interactor: FeedModuleInteractorInput!
    var router: FeedModuleRouterInput!
    
    weak var moduleOutput: FeedModuleOutput?
    weak var userHolder: UserHolder?
    
    var layout: FeedModuleLayoutType = .list {
        didSet {
            onLayoutTypeChange()
        }
    }
    
    var feedType: FeedType? {
        didSet {
            onFeedTypeChange()
        }
    }
    
    fileprivate var isViewReady = false
    fileprivate var formatter = DateFormatterTool()
    fileprivate var cursor: String? = nil
    fileprivate var limit: Int32 = Int32(Constants.Feed.pageSize)
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
    
    func refreshData() {
        fetchAllItems()
    }
    
    // MARK: Private
    
    private func collectionPaddingNeeded() -> Bool {
        return isHomeFeedType()
    }
    
    private func onLayoutTypeChange() {
        view.setLayout(type: self.layout)
        view.paddingEnabled = collectionPaddingNeeded()
        fetchAllItems()
    }
    
    private func onFeedTypeChange() {
        Logger.log(self.feedType)
        if isViewReady {
            view.resetFocus()
            fetchAllItems()
        }
    }
    
    fileprivate func isHomeFeedType() -> Bool {
        return feedType == .home
    }
 
    private func fetchItems(with cursor: String? = nil) {
        guard let feedType = self.feedType else {
            Logger.log("feed type is not set")
            return
        }

        interactor.fetchPosts(limit: limit, cursor: cursor, feedType: feedType)
    }
    
    fileprivate func fetchAllItems() {
        cursor = nil
        fetchItems()
    }
    
    fileprivate func fetchMoreItems(with cursor: String?) {
        
        guard let cursor = cursor else {
            Logger.log("cant fetch, no cursor")
            return
        }
        
        fetchItems(with: cursor)
    }
    
    // MARK: FeedModuleViewOutput
    func item(for path: IndexPath) -> PostViewModel {
        
        let index = path.row
        let item = items[index]
        
        let onAction: PostViewModel.ActionHandler = { [weak self] action, path in
            self?.handle(action: action, path: path)
        }
        
        let itemViewModel = PostViewModel(with: item,
                                          cellType: layout.cellType,
                                          actionHandler: onAction)
    
        return itemViewModel
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

    func handle(action: FeedPostCellAction, path: IndexPath) {
        
        guard isUserAuthorizedToPerformAction(action) else {
            router.open(route: .login, feedSource: feedType!)
            return
        }
        
        let index = path.row
        let postHandle = items[index].topicHandle!
        let userHandle = items[index].userHandle!
        let post = items[index]
        
        switch action {
        case .comment:
            router.open(route: .comments(post: item(for: path)), feedSource: feedType!)
        case .extra:
            
            let isMyPost = (userHolder?.me?.uid == userHandle)
            
            if isMyPost {
                router.open(route: .myPost(post: post), feedSource: feedType!)
            } else {
                router.open(route: .othersPost(post: post), feedSource: feedType!)
            }
        case .like:
            
            let status = items[index].liked
            let action: PostSocialAction = status ? .unlike : .like
            
            items[index].liked = !status
            
            if action == .like {
                items[index].totalLikes += 1
            } else if action == .unlike && items[index].totalLikes > 0 {
                items[index].totalLikes -= 1
            }
            
            view.reload(with: index)
            interactor.postAction(post: postHandle, action: action)
            
        case .pin:
            let status = items[index].pinned
            let action: PostSocialAction = status ? .unpin : .pin
            
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
            
        case .likesList:
            router.open(route: .likesList(postHandle: post.topicHandle), feedSource: feedType!)
        }
        
    }
    
    func isUserAuthorizedToPerformAction(_ action: FeedPostCellAction) -> Bool {
        guard userHolder?.me == nil else { return true }
        return !action.requiresAuthorization
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func viewIsReady() {
        view.setupInitialState()
        view.paddingEnabled = collectionPaddingNeeded()
        view.setLayout(type: layout)
        if let header = header {
            view.registerHeader(withType: header.type, configurator: header.configurator)
        }
        isViewReady = true
    }
    
    func viewDidAppear() {
        limit = Int32(view.itemsLimit)
        didAskFetchAll()
    }
    
    func didAskFetchAll() {
        fetchAllItems()
    }
    
    func didAskFetchMore() {
       fetchMoreItems(with: cursor)
    }
    
    func didTapItem(path: IndexPath) {
        router.open(route: .postDetails(post: item(for: path)), feedSource: feedType!)
    }
    
    // MARK: FeedModuleInteractorOutput
    func didFetch(feed: Feed) {
        
        guard feedType == feed.feedType else {
            return
        }
        
        cursor = feed.cursor
        items = feed.items
        
        view.reload()
    }
    
    func didFetchMore(feed: Feed) {
        
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
    
    func setHeaderHeight(_ height: CGFloat) {
        guard var header = header else { return }
        header.size = CGSize(width: header.size.width, height: height)
        self.header = header
        view.refreshLayout()
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
        var size: CGSize
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
        
        if isHomeFeedType() {
            
            // Refetch Data
            fetchAllItems()
            
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
       
        if isHomeFeedType() {
            
            // Refetch Data
            fetchAllItems()
            
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
        fetchAllItems()
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

