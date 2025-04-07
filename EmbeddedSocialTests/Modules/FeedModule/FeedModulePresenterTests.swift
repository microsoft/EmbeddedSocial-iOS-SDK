//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial
import Nimble

class FeedModulePresenter_Tests: XCTestCase {
    
    var sut: FeedModulePresenter!
    private var view: FeedModuleViewInputMock!
    private var interactor: FeedModuleInteractorInputMock!
    private var router: FeedModuleRouterInputMock!
    private var coreDataStack: CoreDataStack!
    private var database: MockTransactionsDatabaseFacade!
    private var cache: Cache!
    
    private let timeout: TimeInterval = 5

    func setupCache() {
        super.setUp()
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        database = MockTransactionsDatabaseFacade(incomingRepo: CoreDataRepository(context: coreDataStack.mainContext),
                                                  outgoingRepo: CoreDataRepository(context: coreDataStack.mainContext))
        cache = Cache(database: database)
    }

    override func setUp() {
        super.setUp()
        
        sut = FeedModulePresenter()

        view = FeedModuleViewInputMock()
        sut.view = view
        
        sut.feedType = .home
        
        interactor = FeedModuleInteractorInputMock()
        sut.interactor = interactor
        
        router = FeedModuleRouterInputMock()
        sut.router = router
        
        setupCache()
    }
    
    func testThatViewModelIsCorrect() {
        
        // given
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.day = -2
        
        let creationDate = calendar.date(byAdding: comps, to: Date())
        
        let user = User(firstName: firstName,
                        lastName: lastName)
        
        var post = Post.mock(seed: 0)
        
        post.topicHandle = "handle"
        post.user = user
        post.pinned = false
        post.liked = true
        post.title = "post 1 mocked"
        post.totalLikes = 1
        post.totalComments = 2
        post.createdTime = creationDate
        
        let posts = [post]
        let request = sut.makeFetchRequest(limit: 10, feedType: .home)
        let feedResponse = Feed(query: nil,
                                fetchID: request.uid,
                                feedType: .home,
                                items: posts,
                                cursor: nil)
        
        sut.currentItems = feedResponse.items
        let path = IndexPath(row: 0, section: 0)
        
        // when
        let viewModel = sut.item(for: path)
        
        // then
        XCTAssertTrue(viewModel.isLiked == true)
        XCTAssertTrue(viewModel.isPinned == false)
        XCTAssertTrue(viewModel.userName == User.fullName(firstName: firstName, lastName: lastName))
        XCTAssertTrue(viewModel.totalLikes == "1 like")
        XCTAssertTrue(viewModel.totalComments == "2 comments")
        XCTAssertTrue(viewModel.timeCreated == "2d")
    }
    
    func testThatViewHandlesEndOfFetching() {
        
        // given
        view.setRefreshing_state_ReceivedState = true
        
        // when
        sut.didFinishFetching(with: nil)
        
        // then
        XCTAssertTrue(view.setRefreshing_state_ReceivedState == false)
    }
    
    func testThatViewHandlesStartOfFetching() {
        
        // given
        view.setRefreshing_state_ReceivedState = false
        
        // when
        sut.didStartFetching()
        
        // then
        XCTAssertTrue(view.setRefreshing_state_ReceivedState == true)
    }
    
//    func testThatFetchFeedProducesCorrectItems() {
//
//        // given
//        let post = Post.mock(seed: 10)
//        let feed = Feed(fetchID: uniqueString(), feedType: .home, items: [post], cursor: nil)
//
//        // when
//        sut.
//        sut.didFetch(feed: feed)
//
//        // then
//        XCTAssertTrue(sut.item(for: IndexPath(row: 0, section: 0)).title == "Title 10")
//        XCTAssertTrue(sut.numberOfItems() == 1)
//    }
    
//    func testThatFetchMoreHandlesFeedCorrectly() {
//
//        // given
//        let initialPost = Post.mock(seed: 1)
//        let initialFeed = Feed(fetchID: uniqueString(), feedType: .home, items: [initialPost], cursor: nil)
//        sut.didFetch(feed: initialFeed)
//
//        let morePosts = [Post.mock(seed: 2), Post.mock(seed: 3)]
//        let moreFeed = Feed(fetchID: uniqueString(), feedType: .home, items: morePosts, cursor: "cursor")
//
//        // when
//        sut.didFetchMore(feed: moreFeed)
//
//        // then
//        XCTAssertTrue(sut.item(for: IndexPath(row: 0, section: 0)).title == "Title 1")
//        XCTAssertTrue(sut.item(for: IndexPath(row: 1, section: 0)).title == "Title 2")
//        XCTAssertTrue(sut.numberOfItems() == 3)
//        XCTAssertTrue(view.reload_Called == true)
//        XCTAssertTrue(view.reload_Called_Times == 2)
//    }

    func testThatOnFeedTypeChangeFetchIsDone() {
        
        // given
        let feedType = FeedType.single(post: "handle")
        sut.feedType = feedType
        
        // when
        sut.refreshData()
        
        // then
        XCTAssertTrue(interactor.fetchPostsRequestReceivedRequest?.feedType == FeedType.single(post: "handle"))
    }
    
//    func testThatFetchDataTriggersViewReload() {
//
//        // given
//        let feed = Feed(fetchID: uniqueString(),
//                        feedType: .home,
//                        items: [Post.mock(seed: 0)],
//                        cursor: "cursor")
//
//        // when
//        sut.didFetch(feed: feed)
//
//        // then
//        XCTAssertTrue(view.reload_Called == true)
//    }
    
    func testThatLayoutChanges() {
        
        // given
        let layout = FeedModuleLayoutType.grid
        XCTAssertTrue(view.setLayoutReceivedType != layout)
        
        // when
        sut.layout = layout
        
        // then
        XCTAssertTrue(view.setLayoutReceivedType == layout)
    }
    
    func testThatItProducesCorrectRoutesForCellActionsWithRegularUser() {
        
        // setup
        let postUserHandle = UUID().uuidString
        let postImageURL = UUID().uuidString
        let postHandle = UUID().uuidString
        let user = User(uid: postUserHandle)
        
        var post = Post.mock(seed: 1)
        
        post.user = user
        post.imageUrl = postImageURL
        
        let fetchRequestID = uniqueString()
        
        // register fetch request
        _ = sut.makeFetchRequest(requestID: fetchRequestID, limit: 10, feedType: .home)
        
        let feedResponse = Feed(query: nil,
                                fetchID: fetchRequestID,
                                feedType: .home,
                                items: [post],
                                cursor: "cursor")
        
        // stub response
        sut.didFetch(feed: feedResponse)
        sut.currentItems = feedResponse.items
        
        let path = IndexPath(row: 0, section: 0)
        let postViewModel = PostViewModel(with: post, cellType: "")
        
        var testsForOtherUser = [FeedModuleRoutes: FeedPostCellAction]()
        testsForOtherUser[FeedModuleRoutes.comments(post: postViewModel)] = FeedPostCellAction.comment
        testsForOtherUser[FeedModuleRoutes.othersPost(post: post)] = FeedPostCellAction.extra
        testsForOtherUser[FeedModuleRoutes.likesList(postHandle: postHandle)] = FeedPostCellAction.likesList
        testsForOtherUser[FeedModuleRoutes.openImage(image: postImageURL)] = FeedPostCellAction.photo
        testsForOtherUser[FeedModuleRoutes.profileDetailes(user: postUserHandle)] = FeedPostCellAction.profile
        
        for (expectedResult, action) in testsForOtherUser {
            
            // given
            router.open_route_feedSource_ReceivedArguments = nil
            
            // when
            sut.handle(action: action, path: path)
            
            // then
            XCTAssertEqual(router.open_route_feedSource_ReceivedArguments?.route, expectedResult)
        }
        
        var testsForMyUser = [FeedModuleRoutes: FeedPostCellAction]()
        testsForMyUser[FeedModuleRoutes.myPost(post: post)] = FeedPostCellAction.extra
        testsForMyUser[FeedModuleRoutes.myProfile] = FeedPostCellAction.profile
        
        for (expectedResult, action) in testsForMyUser {
            
            // given
            router.open_route_feedSource_ReceivedArguments = nil
            
            // when
            sut.handle(action: action, path: path)
            
            // then
        
            XCTAssertEqual(router.open_route_feedSource_ReceivedArguments?.route, expectedResult)
        }

    }
    
    func testThatItProducesCorrectRoutesForCellActionsWithMyUser() {
        
        // given
        
        let myUserHandle = UUID().uuidString
        let userHolder = UserHolderMock()
        userHolder.me!.uid = myUserHandle
        
        sut.userHolder = userHolder
    
        let postImageURL = UUID().uuidString
        
        var post = Post.mock(seed: 1)
        let user = User(uid: myUserHandle)
        
        post.user = user
        post.imageUrl = postImageURL
        
        
        let fetchRequestID = uniqueString()
        
        // register fetch request
        _ = sut.makeFetchRequest(requestID: fetchRequestID, limit: 10, feedType: .home)
        
        let feedResponse = Feed(query: nil,
            fetchID: fetchRequestID,
                        feedType: .home,
                        items: [post],
                        cursor: "cursor")
        // stub response
        sut.currentItems = feedResponse.items
        
        let path = IndexPath(row: 0, section: 0)
        
        // extra event testing
        router.open_route_feedSource_ReceivedArguments = nil
        sut.handle(action: .extra, path: path)
        XCTAssertEqual(router.open_route_feedSource_ReceivedArguments?.route, .myPost(post: post))
        
        
        // profile event testing
        router.open_route_feedSource_ReceivedArguments = nil
        sut.handle(action: .profile, path: path)
        XCTAssertEqual(router.open_route_feedSource_ReceivedArguments?.route, .myProfile)
    }
    
    func testThatItOpensLoginWhenAnonymousUserAttemptsToPerformLikeOrPin() {
        performActionAndValidateLoginOpened(.pin)
        performActionAndValidateLoginOpened(.like)
    }
    
    func performActionAndValidateLoginOpened(_ action: FeedPostCellAction) {
        // given
        let userHolder = UserHolderMock()
        userHolder.me = nil
        
        sut.userHolder = userHolder
        
        // when
        sut.handle(action: action, path: IndexPath())
        
        // then
        XCTAssertTrue(router.open_route_feedSource_Called)
        XCTAssertEqual(router.open_route_feedSource_ReceivedArguments?.route, .login)
    }
}

