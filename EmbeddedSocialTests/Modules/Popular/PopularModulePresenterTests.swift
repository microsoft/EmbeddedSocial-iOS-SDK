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
            
            configurator.configure( moduleOutput: output)
            configurator.viewController = UIViewController()
            configurator.moduleInput = feedModule
            
            return configurator
        }
        
    }

    func testThatPresenterLoadsViewCorrectly() {
    
        // given
      
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertTrue(view.didEmbedViewController)
        XCTAssertTrue(view.availableFeeds != nil)
        XCTAssertTrue(view.feedType != nil)
    }
    
    func testThatFeedChangeTriggersSubmodule() {
        
        // given
        sut.viewIsReady()
        
        // when
        sut.feedTypeDidChange(to: 0)
        
        // then
//        XCTAssertTrue(view.didLockFeed)
//        XCTAssertTrue(view.didUnlockFeed)
        
    }
    
    func testThatViewGetsLockedUnlocked() {
        
        // when 
        sut.didStartRefreshingData()
        
    }

}
