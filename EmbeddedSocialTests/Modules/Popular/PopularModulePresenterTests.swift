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
}

private class FeedModuleMock: FeedModuleInput {

    var didSetFeed: FeedType?
    func setFeed(_ feed: FeedType) {
        didSetFeed = feed
    }

    var didRefreshData = false
    func refreshData() {
        didRefreshData = true
    }

    var layout: FeedModuleLayoutType = .list
    
    
    // Unused
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type,
                        size: CGSize,
                        configurator: @escaping (T) -> Void) {}
    func moduleHeight() -> CGFloat {}
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

    func testThatPresenterLoadsCorrectly() {
    
        // given
      
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertTrue(view.didEmbedViewController)
        XCTAssertTrue(view.availableFeeds != nil)
        XCTAssertNotNil(view.feedType)
        XCTAssertNotNil(feedModule.didSetFeed)
        XCTAssertTrue(feedModule.didRefreshData)
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
        XCTAssertNotNil(feedModule.didSetFeed)
        XCTAssertTrue(feedModule.didSetFeed == .popular(type: FeedType.TimeRange.weekly))
    }
    
    func testThatViewGetsLocked() {
        
        // when 
        sut.didStartRefreshingData()
    
        // then
        XCTAssertTrue(view.didLockFeed)
    }
    
    func testThatViewGetsUnlocked() {
        
        // when
        sut.didFinishRefreshingData(nil)
        // then
        XCTAssertTrue(view.didUnlockFeed)
    }
    
    func testThatViewHandlesEror() {
        
        // given
        let error = NSError(domain: "test error", code: 0, userInfo: nil)
        
        // when
        sut.didFinishRefreshingData(error)
        
        // then
        XCTAssertTrue(view.didUnlockFeed)
        XCTAssertNotNil(view.didHandleError)
    }

    
}
