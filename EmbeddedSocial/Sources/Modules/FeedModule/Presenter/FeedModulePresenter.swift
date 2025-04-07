//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import BMACollectionBatchUpdates

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

enum FeedPostCellAction {
    case like, pin, comment, extra, profile, photo, likesList, postDetailed
    case hashtag(String)
    
    var requiresAuthorization: Bool {
        switch self {
        case .like, .pin:
            return true
        default:
            return false
        }
    }
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
        return currentItems.isEmpty
    }
    
    fileprivate var isViewReady = false
    fileprivate var formatter = DateFormatterTool()
    fileprivate var cursor: String? = nil
    fileprivate let defaultLimit: Int32 = Int32(Constants.Feed.pageSize)
    var currentItems: [Post] = [Post]() {
        didSet {
            checkIfNoContent()
        }
    }
    fileprivate var fetchRequestsInProgress: Set<String> = Set()
    fileprivate var header: SupplementaryItemModel?
    
    var headerSize: CGSize {
        return header?.size ?? .zero
    }
    
    fileprivate let settings: Settings
    
    init(settings: Settings = AppConfiguration.shared.settings) {
        self.settings = settings
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
        
        guard let feedType = self.feedType else { return false }
        
        switch feedType {
        case .single(post: _):
            return false
        default:
            // All feeds use padding for cells
            return true
        }
    }
    
    private func onLayoutTypeChange() {
        // Invalidate subsequent responses
        fetchRequestsInProgress = Set()
        view.setLayout(type: self.layout)
        view.paddingEnabled = collectionPaddingNeeded()
    }
    
    private func onFeedTypeChange() {
        Logger.log(self.feedType)
        
        if let feedType = feedType, case .search = feedType {
            updateUI(with: [])
        }
        
        if isViewReady {
            view.resetFocus()
            fetchAllItems()
        }
        
        updatePadding()
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
    
    fileprivate func updatePadding() {
        view.paddingEnabled = collectionPaddingNeeded()
    }

    fileprivate func shouldShowNoContent() -> Bool {
        switch feedType! {
            
        // Show no data for all feeds
        default:
            return true
        }
    }
    
    fileprivate func checkIfNoContent() {
        if shouldShowNoContent() {
            view.needShowNoContent(state: currentItems.count == 0)
        }
    }
    
    func makeFetchRequest(requestID: String = UUID().uuidString,
                          cursor: String? = nil,
                          limit: Int32,
                          feedType: FeedType) -> FeedFetchRequest {
        fetchRequestsInProgress.insert(requestID)
        return FeedFetchRequest(uid: requestID, cursor: cursor, limit: limit, feedType: feedType)
    }
 
    private func fetchItems(with cursor: String? = nil, limit: Int32) {
        
        guard let feedType = self.feedType else {
            Logger.log("feed type is not set")
            return
        }

        let request = makeFetchRequest(cursor: cursor, limit: limit, feedType: feedType)
        interactor.fetchPosts(request: request)
    }
    
    fileprivate func fetchAllItems() {
        cursor = nil
        fetchRequestsInProgress = Set()
        fetchItems(limit: defaultLimit)
    }
    
    fileprivate func fetchMoreItems(with cursor: String?, limit: Int32) {
        
        guard let cursor = cursor else {
            Logger.log("cant fetch, no cursor")
            return
        }
        
//        fetchRequestsInProgress = Set()
        fetchItems(with: cursor, limit: limit)
    }
    
    // MARK: FeedModuleViewOutput
    func item(for path: IndexPath) -> PostViewModel {
        
        let index = path.row
        let item = currentItems[index]
        
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
        
        guard let feedType = self.feedType else {
            Logger.log("Trying to work with feed while it's unset", event: .veryImportant)
            return
        }
        
        guard isUserAuthorizedToPerformAction(action) else {
            router.open(route: .login, feedSource: feedType)
            return
        }
        
        let index = path.row
        let userHandle = currentItems[index].userHandle
        let post = currentItems[index]
        
        switch action {
            
        case .postDetailed:
            if moduleOutput is PostDetailPresenter {
                return
            }
            
            router.open(route: .postDetails(post: item(for: path)), feedSource: feedType)
        case .comment:
            if moduleOutput is PostDetailPresenter {
                moduleOutput?.commentsPressed()
                return
            }
            
            router.open(route: .comments(post: item(for: path)), feedSource: feedType)
            moduleOutput?.commentsPressed()
        case .extra:
            
            let isMyPost = (userHolder?.me?.uid == userHandle)
            
            if isMyPost {
                router.open(route: .myPost(post: post), feedSource: feedType)
            } else {
                router.open(route: .othersPost(post: post), feedSource: feedType)
            }
        case .like:
            
            var newItems = currentItems
            let status = newItems[index].liked
            let action: PostSocialAction = status ? .unlike : .like
            
            newItems[index].liked = !status
 
            if action == .like {
                newItems[index].totalLikes += 1
            } else if action == .unlike && newItems[index].totalLikes > 0 {
                newItems[index].totalLikes -= 1
            }
            
            updateUI(with: newItems)
            interactor.postAction(post: currentItems[index], action: action)
            
        case .pin:
            var newItems = currentItems
            let status = newItems[index].pinned
            let action: PostSocialAction = status ? .unpin : .pin
            
            newItems[index].pinned = !status
            
            updateUI(with: newItems)
            interactor.postAction(post: currentItems[index], action: action)
            
        case .profile:
            guard moduleOutput?.shouldOpenProfile(for: userHandle) ?? true else { return }
            
            let isMyProfile = userHolder?.me?.uid == userHandle
            
            if isMyProfile {
                router.open(route: .myProfile, feedSource: feedType)
            } else {
                router.open(route: .profileDetailes(user: userHandle), feedSource: feedType)
            }
            
        case .photo:
            guard let imageUrl = currentItems[path.row].imageUrl else {
                return
            }
            
            router.open(route: .openImage(image: imageUrl), feedSource: feedType)
            
        case .likesList:
            router.open(route: .likesList(postHandle: post.topicHandle), feedSource: feedType)
            
        case .hashtag(let value):
            router.open(route: .search(hashtag: value), feedSource: feedType)
        }
    }
    
    func isUserAuthorizedToPerformAction(_ action: FeedPostCellAction) -> Bool {
        guard userHolder?.me == nil else { return true }
        return !action.requiresAuthorization
    }
    
    func numberOfItems() -> Int {
        return currentItems.count
    }
    
    func viewIsReady() {
        view.setupInitialState(showGalleryView: settings.showGalleryView)
        updatePadding()
        
        if let header = header {
            view.registerHeader(withType: header.type, configurator: header.configurator)
        }
        
        view.setLayout(type: layout)
        isViewReady = true
    }
    
    func viewDidAppear() {
        
        if shouldFetchOnViewAppear() {
            didAskFetchAll()
        }
    }
    
    func didAskFetchAll() {
        fetchAllItems()
    }
    
    func didAskFetchMore() {
       fetchMoreItems(with: cursor, limit: defaultLimit)
    }
    
    func didTapItem(path: IndexPath) {
        handle(action: .postDetailed, path: path)
    }

    // MARK: FeedModuleInteractorOutput
    
    private func shouldFullFillFeed(feed: FeedType) -> Bool {
        switch feed {
        case .single(post: _ ):
            return false
        default:
            return true
        }
    }
    
    private func processFetchResult(feed: Feed, isMore: Bool) {
        
        guard fetchRequestsInProgress.contains(feed.fetchID), feedType == feed.feedType else {
            return
        }
        
//        print("items got \(feed.items.count) for limit \(feed.query?.limit) with cursor \(feed.query?.cursor)")
        
        cursor = feed.cursor
        
        let initialItems: [Post] = isMore ? currentItems : []
        let newItems = initialItems + feed.items
        
        updateUI(with: newItems)
        
        // re-fetch missing items
        if !feed.isFullfilled() && shouldFullFillFeed(feed: feed.feedType) {
//            print("requesting cursor \(feed.cursor), with limit\(feed.missingItems())")
            fetchMoreItems(with: feed.cursor, limit: feed.missingItems())
        }
    }
    
    func updateUI(with newItems: [Post]) {
        let oldItems = self.currentItems.map { BatchCollectionItem(post: $0) }
        let oldSection = BatchCollection(uid: "0", items: oldItems)
        
        let newItems = newItems.map { BatchCollectionItem(post: $0) }
        let newSection = BatchCollection(uid: "0", items: newItems)
        
        BMACollectionUpdate.calculateUpdates(forOldModel: [oldSection],
                                             newModel: [newSection],
                                             sectionsPriorityOrder: nil,
                                             eliminatesDuplicates: true) { (sections, updates) in
                                            
                                                self.view.performBatches(updates: updates, withSections: sections)
                                                
        }
    }
    
    func didUpdateFeed() {
        moduleOutput?.didUpdateFeed()
    }
    
    func didFetch(feed: Feed) {
        processFetchResult(feed: feed, isMore: false)
    }
    
    func didFetchMore(feed: Feed) {
        processFetchResult(feed: feed, isMore: true)
    }
    
    func didFail(error: Error) {
        Logger.log(error, event: .error)
    }
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        Logger.log(action, post, error)
    }
    
    func didStartFetching() {
        Logger.log()
        view.setRefreshing(state: true)
        moduleOutput?.didStartRefreshingData()
    }
    
    func didFinishFetching(with error: Error?) {
        Logger.log()
        view.setRefreshing(state: false)
        moduleOutput?.didFinishRefreshingData(error)
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
    
    func didUpdateTopicHandle(from oldHandle: String, to newHandle: String) {
        guard let idx = currentItems.index(where: { $0.topicHandle == oldHandle }) else { return }
        
        var itemToUpdate = currentItems[idx]
        itemToUpdate.topicHandle = newHandle
        currentItems[idx] = itemToUpdate
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
            var newItems = currentItems
            for (index, item) in newItems.enumerated() {
                if item.userHandle == user.uid {
                    newItems[index].userStatus = .accepted
                }
            }
            
            updateUI(with: newItems)
        }
    }
    
    func didUnfollow(user: User) {
       
        if isHomeFeedType() {
            
            // Refetch Data
            fetchAllItems()
            
        } else {
            
            // Update following status for current posts
            var newItems = currentItems
            for (index, item) in newItems.enumerated() {
                if item.userHandle == user.uid && item.userStatus == .accepted {
                    newItems[index].userStatus = .empty
                }
            }
            
            updateUI(with: newItems)
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

    private func didChangeItem(post: PostHandle) {
       
        // TODO: need check offline mode
    }
    
    private func didRemoveItem(post: PostHandle) {
        var newItems = currentItems
        if let index = newItems.index(where: { $0.topicHandle == post }) {
            newItems.remove(at: index)
            updateUI(with: newItems)
        }
    }
    
    private func didFail(_ error: Error) {
        view.showError(error: error)
    }
}

