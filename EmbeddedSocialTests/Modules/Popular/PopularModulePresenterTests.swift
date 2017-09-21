//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class PopularModuleViewMock: PopularModuleViewInput {
    
    var feedType: Int?
    func setCurrentFeedType(to index: Int) {
        feedType = index
    }
    
    var availableFeeds: [String]?
    func setFeedTypesAvailable(types: [String]) {
        availableFeeds = types
    }
    
    var didLockFeed = false
    func lockFeedControl() {
        didLockFeed = true
    }
    
    var didUnlockFeed = false
    func unlockFeedControl() {
        didUnlockFeed = true
    }
    
    var didHandleError: Error?
    func handleError(error: Error) {
        didHandleError = error
    }
    
    var didEmbedViewController = false
    func embedFeedViewController(_ viewController: UIViewController) {
        didEmbedViewController = true
    }
    
    var didSetImage: UIImage?
    func setFeedLayoutImage(_ image: UIImage) {
        didSetImage = image
    }
}

private class FeedModuleMock: FeedModuleInput {

    var feedType: FeedType?
    
    var didRefreshData = false
    
    func refreshData() {
        didRefreshData = true
    }

    var layout: FeedModuleLayoutType = .list
    var setHeaderHeightCalled = false
    var headerHeight: CGFloat? = nil
    var isEmpty = false
    
    func setHeaderHeight(_ height: CGFloat) {
        setHeaderHeightCalled = true
        headerHeight = height
    }
    
    var lockScrollingCount = 0
    func lockScrolling() {
        lockScrollingCount += 1
    }
}

extension FeedModuleMock {
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type,
                        size: CGSize,
                        configurator: @escaping (T) -> Void) {}
    
    func moduleHeight() -> CGFloat { return 0 }
}


class PopularModulePresenterTests: XCTestCase {
    
    var sut: PopularModulePresenter!
    private var view: PopularModuleViewMock!
    var router: PopularModuleRouter!
    private var feedModule: FeedModuleMock!
    
    override func setUp() {
        super.setUp()
        
        sut = PopularModulePresenter()
        view = PopularModuleViewMock()
        sut.view = view
        
        router = PopularModuleRouter()
        router.navigationController = UINavigationController()
        sut.router = router
        
        feedModule = FeedModuleMock()
        
        sut.configuredFeedModule = { [feedModule] navigationController, output in
            
            let configurator = FeedModuleConfigurator()
            
            configurator.configure(moduleOutput: output)
            configurator.viewController = UIViewController()
            configurator.moduleInput = feedModule
            
            return configurator
        }
        
    }
    
    // MARK: PopularModuleViewOutput

    func testThatPresenterLoadsCorrectly() {
    
        // given
        let correctFeedType = FeedType.popular(type: Constants.Feed.Popular.initialFeedScope)
      
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertTrue(view.didEmbedViewController)
        XCTAssertTrue(view.availableFeeds != nil)
        XCTAssertTrue(feedModule.feedType == correctFeedType)
    }
    
    func testThatFeedChangesFeedModule() {
        
        // given
        sut.feedMapping = [
            (feed: FeedType.TimeRange.today, title: L10n.PopularModule.FeedOption.today),
            (feed: FeedType.TimeRange.weekly, title: L10n.PopularModule.FeedOption.thisWeek),
            (feed: FeedType.TimeRange.alltime, title: L10n.PopularModule.FeedOption.allTime)
        ]
        
        sut.viewIsReady()
        
        // when
        sut.feedTypeDidChange(to: 1)
        
        // then
        XCTAssertNotNil(feedModule.feedType)
        XCTAssertTrue(feedModule.feedType == .popular(type: FeedType.TimeRange.weekly))
    }

    // MARK: FeedModuleOutput
    
    func testThatViewHandlesStartOfFetching() {
        
        // when 
        sut.didStartRefreshingData()
    
        // then
        XCTAssertTrue(view.didLockFeed)
    }
    
    func testThatViewHandlesEndOfFetching() {
        
        // when
        sut.didFinishRefreshingData(nil)
        // then
        XCTAssertTrue(view.didUnlockFeed)
    }
    
    func testThatViewHandlesError() {
        
        // given
        let error = NSError(domain: "test error", code: 0, userInfo: nil)
        
        // when
        sut.didFinishRefreshingData(error)
        
        // then
        XCTAssertTrue(view.didUnlockFeed)
        XCTAssertNotNil(view.didHandleError)
    }
    
    func testsThatItHandlesLayoutTypeChangeEvent() {
        
        // given
        sut.viewIsReady()
        view.didSetImage = nil

        // when
        sut.feedLayoutTypeChangeDidTap()
        
        // then
        XCTAssertTrue(view.didSetImage != nil)
    }
    
}
