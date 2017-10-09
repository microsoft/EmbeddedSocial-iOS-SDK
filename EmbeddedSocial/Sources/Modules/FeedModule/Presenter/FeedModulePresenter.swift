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
    func lockScrolling()
    
    var isEmpty: Bool { get }
}

protocol FeedModuleOutput: class {
    func didScrollFeed(_ feedView: UIScrollView)
    
    func didStartRefreshingData()
    func didFinishRefreshingData(_ error: Error?)
    func didUpdateFeed()
    func postRemoved()
    func commentsPressed()
    func shouldOpenProfile(for userID: String) -> Bool
}

extension FeedModuleOutput {
    func didScrollFeed(_ feedView: UIScrollView) { }
    
    func didStartRefreshingData() { }
    func didFinishRefreshingData(_ error: Error?) { }
    func didUpdateFeed() { }
    func commentsPressed() { }
    func postRemoved() { }
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
    case like, pin, comment, extra, profile, photo, likesList, postDetailed
    
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
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    fileprivate var isViewReady = false
    fileprivate var formatter = DateFormatterTool()
    fileprivate var cursor: String? = nil
    fileprivate var limit: Int32 = Int32(Constants.Feed.pageSize)
    fileprivate var items = [Post]()
    fileprivate var fetchRequestsInProgress: Set<String> = Set()
    fileprivate var header: SupplementaryItemModel?
    
    var headerSize: CGSize {
        return header?.size ?? .zero
    }
    
    func didTapChangeLayout() {
        layout = layout.flipped
    }
    
    // MARK: FeedModuleInput
    
    func lockScrolling() {
        if moduleOutput is PostDetailPresenter {
            view.setScrolling(enable: false)
        }
    }
    
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
        // Invalidate subsequent responses
        fetchRequestsInProgress = Set()
        view.setLayout(type: self.layout)
        view.paddingEnabled = collectionPaddingNeeded()
    }
    
    private func onFeedTypeChange() {
        Logger.log(self.feedType)
        if isViewReady {
            view.resetFocus()
            fetchAllItems()
        }
    }
    
    fileprivate func shouldFetchOnViewAppear() -> Bool {
        
        guard let feedType = feedType else {
            return false
        }
        
        switch feedType {
        case .popular(type: _ ):
            return false
        default:
            return true
        }
    }
    
    fileprivate func isHomeFeedType() -> Bool {
        return feedType == .home
    }
    
    fileprivate func checkIfNoContent() {
        if isHomeFeedType() {
            view.needShowNoContent(state: items.count == 0)
        }
    }
    
    func makeFetchRequest(requestID: String = UUID().uuidString, cursor: String? = nil, feedType: FeedType) -> FeedFetchRequest {
        fetchRequestsInProgress.insert(requestID)
        return FeedFetchRequest(uid: requestID, cursor: cursor, limit: limit, feedType: feedType)
    }
 
    private func fetchItems(with cursor: String? = nil) {
        guard let feedType = self.feedType else {
            Logger.log("feed type is not set")
            return
        }

        let request = makeFetchRequest(cursor: cursor, feedType: feedType)
        interactor.fetchPosts(request: request)
    }
    
    fileprivate func fetchAllItems() {
        cursor = nil
        items = []
        view.reload()
        fetchRequestsInProgress = Set()
        fetchItems()
    }
    
    fileprivate func fetchMoreItems(with cursor: String?) {
        
        guard let cursor = cursor else {
            Logger.log("cant fetch, no cursor")
            return
        }
        
        fetchRequestsInProgress = Set()
        fetchItems(with: cursor)
    }
    
    // MARK: FeedModuleViewOutput
    func item(for path: IndexPath) -> PostViewModel {
        
        let index = path.row
        let item = items[index]
        
        let onAction: PostViewModel.ActionHandler = { [weak self] action, path in
            self?.handle(action: action, path: path)
        }
    
        // trimmed text for post cell
        var isTrimmed = true
        switch feedType! {
        case .single(post: _):
            isTrimmed = false
        default:
            isTrimmed = true
        }
        
        let itemViewModel = PostViewModel(with: item,
                                          isTrimmed: isTrimmed,
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
        let userHandle = items[index].userHandle
        let post = items[index]
        
        switch action {
            
        case .postDetailed:
            if moduleOutput is PostDetailPresenter {
                return
            }
            
            router.open(route: .postDetails(post: item(for: path)), feedSource: feedType!)
        case .comment:
            if moduleOutput is PostDetailPresenter {
                moduleOutput?.commentsPressed()
                return
            }
            
            router.open(route: .comments(post: item(for: path)), feedSource: feedType!)
            moduleOutput?.commentsPressed()
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
            
            // change item locally
            // TODO: remove this, since it's responsibility of outgoing cache 
            if action == .like {
                items[index].totalLikes += 1
            } else if action == .unlike && items[index].totalLikes > 0 {
                items[index].totalLikes -= 1
            }
            
            view.reload(with: index)
            interactor.postAction(post: items[index], action: action)
            
        case .pin:
            let status = items[index].pinned
            let action: PostSocialAction = status ? .unpin : .pin
            
            items[index].pinned = !status
            
            view.reload(with: index)
            interactor.postAction(post: items[index], action: action)
            
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
        
        if let header = header {
            view.registerHeader(withType: header.type, configurator: header.configurator)
        }
        
        view.setLayout(type: layout)
        isViewReady = true
    }
    
    func viewDidAppear() {
        limit = Int32(view.itemsLimit)
        
        if shouldFetchOnViewAppear() {
            didAskFetchAll()
        }
    }
    
    func didAskFetchAll() {
        fetchAllItems()
    }
    
    func didAskFetchMore() {
       fetchMoreItems(with: cursor)
    }
    
    func didTapItem(path: IndexPath) {
        handle(action: .postDetailed, path: path)
    }
    
    // MARK: FeedModuleInteractorOutput
    
    private func processFetchResult(feed: Feed, isMore: Bool) {
        
        guard fetchRequestsInProgress.contains(feed.fetchID), feedType == feed.feedType else {
            return
        }
        
        Logger.log("items arrived", event: .veryImportant)
        
        let cachedNumberOfItems = items.count
        
        if isMore {
            appendWithReplacing(original: &items, appending: feed.items)
        } else {
            items = feed.items
        }
        
        cursor = feed.cursor
        
        // show changes on UI
        let shouldAddItems = items.count - cachedNumberOfItems
        let shouldRemoveItems = cachedNumberOfItems - items.count
        
        // insert/remove items
        if cachedNumberOfItems == 0 {
            view.reload()
        }
        else {
            
            if shouldAddItems > 0 {
                let paths = Array(cachedNumberOfItems..<items.count).map { IndexPath(row: $0, section: 0) }
                view.insertNewItems(with: paths)
            }
            else if shouldRemoveItems > 0 {
                let paths = Array(items.count..<cachedNumberOfItems).map { IndexPath(row: $0, section: 0) }
                view.removeItems(with: paths)
            }
            
            // update data for rest of cells
            view.reloadVisible()
        }
    
        // update "No content"
        checkIfNoContent()
    }
    
    func didFetch(feed: Feed) {
        processFetchResult(feed: feed, isMore: false)
    }
    
    func didFetchMore(feed: Feed) {
        processFetchResult(feed: feed, isMore: true)
    }
    
    func didFail(error: Error) {
        view.showError(error: error)
    }
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        view.reload()
        Logger.log(action, post, error)
    }
    
    func didStartFetching() {
        Logger.log()
        view.setRefreshing(state: true)
        if let delegate = moduleOutput {
            delegate.didStartRefreshingData()
        } else {
            view.setRefreshing(state: true)
        }
    }
    
    func didFinishFetching() {
        Logger.log()
        view.setRefreshing(state: false)
        if let delegate = moduleOutput {
            delegate.didFinishRefreshingData(nil)
        } else {
            view.setRefreshing(state: false)
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
    
    func didBlock(user: User) {
        Logger.log("Success")
    }
    
    func didUnblock(user: User) {
        Logger.log("Success")
    }
    
    func didFollow(user: User) {
        
        if isHomeFeedType() {
            
            // Refetch Data
            fetchAllItems()
            
        } else {
            
            // Update following status for current posts
            for (index, item) in items.enumerated() {
                if item.userHandle == user.uid {
                    items[index].userStatus = .accepted
                }
            }
            
            view.reloadVisible()
        }
    }
    
    func didUnfollow(user: User) {
       
        if isHomeFeedType() {
            
            // Refetch Data
            fetchAllItems()
            
        } else {
            
            // Update following status for current posts
            for (index, item) in items.enumerated() {
                if item.userHandle == user.uid && item.userStatus == .accepted {
                    items[index].userStatus = .empty
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
        moduleOutput?.postRemoved()
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
            view.removeItems(with: [IndexPath(row: index, section: 0)])
        }
    }
    
    private func didFail(_ error: Error) {
        view.showError(error: error)
    }
}

