//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class TrendingTopicsPresenterTests: XCTestCase {
    
    var sut: TrendingTopicsPresenter!
    var view: MockTrendingTopicsViewController!
    var interactor: MockTrendingTopicsInteractor!
    var output: MockTrendingTopicsModuleOutput!
    
    override func setUp() {
        super.setUp()
        view = MockTrendingTopicsViewController()
        interactor = MockTrendingTopicsInteractor()
        output = MockTrendingTopicsModuleOutput()
        sut = TrendingTopicsPresenter()
        sut.view = view
        sut.interactor = interactor
        sut.output = output
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        output = nil
        sut = nil
    }
    
    func testThatItLoadsHashtags() {
        let hashtags: [Hashtag] = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        interactor.getTrendingHashtagsCompletionReturnValue = .success(hashtags)
        
        sut.viewIsReady()
        
        expect(self.interactor.getTrendingHashtagsCompletionCalled).toEventually(beTrue())
        
        expect(self.view.setIsLoadingCalled).toEventually(beTrue())
        expect(self.view.setIsLoadingReceivedIsLoading).toEventually(beFalse())
        
        expect(self.view.setHashtagsCalled).toEventually(beTrue())
        expect(self.view.setHashtagsReceivedHashtags).toEventually(equal(hashtags))
    }
    
    func testThatItHandlesLoadHashtagsError() {
        interactor.getTrendingHashtagsCompletionReturnValue = .failure(APIError.unknown)
        
        sut.viewIsReady()
        
        expect(self.interactor.getTrendingHashtagsCompletionCalled).toEventually(beTrue())
        
        expect(self.view.setIsLoadingCalled).toEventually(beTrue())
        expect(self.view.setIsLoadingReceivedIsLoading).toEventually(beFalse())
        
        expect(self.view.setHashtagsCalled).toEventually(beFalse())
        expect(self.view.showErrorCalled).toEventually(beTrue())
        expect(self.view.showErrorReceivedError).toEventually(matchError(APIError.unknown))
    }
    
    func testThatItNotifiesOutputWhenHashtagIsSelected() {
        let item = TrendingTopicsListItem(hashtag: UUID().uuidString)
        sut.onItemSelected(item)
        expect(self.output.didSelectHashtagCalled).to(beTrue())
        expect(self.output.didSelectHashtagReceivedHashtag).to(equal(item.hashtag))
    }
    
    func testThatItReturnsItsViewController() {
        expect(self.sut.viewController).to(equal(view))
    }
    
    func testThatItHandlesPullToRefresh() {
        let hashtags: [Hashtag] = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        interactor.reloadTrendingHashtagsCompletionReturnValue = .success(hashtags)
        
        sut.onPullToRefresh()
        
        expect(self.interactor.reloadTrendingHashtagsCompletionCalled).toEventually(beTrue())
        expect(self.view.setHashtagsReceivedHashtags).toEventually(equal(hashtags))
        expect(self.view.endPullToRefreshAnimationCalled).toEventually(beTrue())
    }
    
    func testThatItHandlesReloadHashtagsError() {
        interactor.reloadTrendingHashtagsCompletionReturnValue = .failure(APIError.unknown)
        
        sut.onPullToRefresh()
        
        expect(self.interactor.reloadTrendingHashtagsCompletionCalled).toEventually(beTrue())
        expect(self.view.setHashtagsCalled).toEventually(beFalse())
        expect(self.view.endPullToRefreshAnimationCalled).toEventually(beTrue())
        expect(self.view.showErrorReceivedError).toEventually(matchError(APIError.unknown))
    }
}
