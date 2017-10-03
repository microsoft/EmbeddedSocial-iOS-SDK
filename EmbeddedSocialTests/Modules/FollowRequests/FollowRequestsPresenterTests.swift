//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class FollowRequestsPresenterTests: XCTestCase {
    var interactor: MockFollowRequestsInteractor!
    var view: MockFollowRequestsView!
    var moduleOutput: MockFollowRequestsModuleOutput!
    var noDataText: NSAttributedString!
    var sut: FollowRequestsPresenter!
    
    override func setUp() {
        super.setUp()
        interactor = MockFollowRequestsInteractor()
        view = MockFollowRequestsView()
        moduleOutput = MockFollowRequestsModuleOutput()
        noDataText = NSAttributedString(string: UUID().uuidString)
        
        sut = FollowRequestsPresenter(noDataText: noDataText)
        sut.view = view
        sut.interactor = interactor
        sut.output = moduleOutput
    }
    
    override func tearDown() {
        super.tearDown()
        interactor = nil
        view = nil
        moduleOutput = nil
        noDataText = nil
        sut = nil
    }
    
    func testThatItSetupsInitialStateWhenViewIsReady() {
        // given
        interactor.getNextListPageCompletionReturnValue = .success([])
        
        // when
        sut.viewIsReady()
        
        // then
        expect(self.view.setupInitialStateCalled).to(beTrue())
        expect(self.view.setNoDataTextCalled).to(beTrue())
        expect(self.view.setNoDataTextReceivedText).to(equal(noDataText))
        
        expect(self.interactor.getNextListPageCompletionCalled).to(beTrue())
    }
    
    func testThatItLoadsNextPage() {
        // given
        let users = [User(), User(), User()]
        interactor.getNextListPageCompletionReturnValue = .success(users)
        
        // when
        sut.loadNextPage()
        
        // then
        validatePageLoaded(with: users)
    }
    
    private func validatePageLoaded(with users: [User]) {
        expect(self.interactor.getNextListPageCompletionCalled).to(beTrue())
        
        expect(self.view.setUsersCalled).to(beTrue())
        expect(self.view.setUsersReceivedUsers).to(equal(users))
        
        expect(self.view.setIsEmptyCalled).to(beTrue())
        expect(self.view.setIsEmptyReceivedIsEmpty).to(equal(users.isEmpty))
    }
    
    func testThatItCorrectlyProcessesPullToRefresh() {
        // given
        let users = [User(), User()]
        interactor.reloadListCompletionReturnValue = .success(users)
        
        // when
        sut.onPullToRefresh()
        
        // then
        expect(self.interactor.reloadListCompletionCalled).to(beTrue())
        
        expect(self.view.setUsersCalled).to(beTrue())
        expect(self.view.setUsersReceivedUsers).to(equal(users))
        
        expect(self.view.endPullToRefreshAnimationCalled).to(beTrue())
        expect(self.view.setIsLoadingCalled).to(beFalse())
    }
    
    func testThatItLoadsNextPageWhenIsReachingEndOfPage() {
        // given
        interactor.isLoadingList = false
        interactor.listHasMoreItems = true
        interactor.getNextListPageCompletionReturnValue = .success([])
        
        // when
        sut.onReachingEndOfPage()
        
        // then
        expect(self.interactor.getNextListPageCompletionCalled).to(beTrue())
    }
    
    func testThatItDoesNotLoadNextPageWhenInteractorIsAlreadyLoadingIt() {
        // given
        interactor.isLoadingList = true
        interactor.listHasMoreItems = true
        interactor.getNextListPageCompletionReturnValue = .success([])
        
        // when
        sut.onReachingEndOfPage()
        
        // then
        expect(self.interactor.getNextListPageCompletionCalled).to(beFalse())
    }
    
    func testThatItDoesNotLoadNextPageWhenInteractorHasNoItemsLeft() {
        // given
        interactor.isLoadingList = false
        interactor.listHasMoreItems = false
        interactor.getNextListPageCompletionReturnValue = .success([])
        
        // when
        sut.onReachingEndOfPage()
        
        // then
        expect(self.interactor.getNextListPageCompletionCalled).to(beFalse())
    }
    
    func testThatItProcessesAcceptRequestAndNotifiesModuleOutput() {
        // given
        let user = User()
        let item = FollowRequestItem(user: user)
        
        interactor.acceptPendingRequestReturnValue = .success()
        
        // when
        sut.onAccept(item)
        
        // then
        expect(self.interactor.acceptPendingRequestToCompletionCalled).to(beTrue())
        
        expect(self.view.setIsLoadingItemCalled).to(beTrue())
        expect(self.view.setIsLoadingItemReceivedArguments?.isLoading).to(beFalse())
        expect(self.view.setIsLoadingItemReceivedArguments?.item.user).to(equal(user))
        
        expect(self.moduleOutput.didAcceptFollowRequestCalled).to(beTrue())
    }
    
    func testThatItProcessesAcceptRequestAndDoesNotNotifyOutputWhenRequestFails() {
        // given
        let user = User()
        let item = FollowRequestItem(user: user)
        
        interactor.acceptPendingRequestReturnValue = .failure(APIError.unknown)
        
        // when
        sut.onAccept(item)
        
        // then
        expect(self.interactor.acceptPendingRequestToCompletionCalled).to(beTrue())
        
        expect(self.view.setIsLoadingItemCalled).to(beTrue())
        expect(self.view.setIsLoadingItemReceivedArguments?.isLoading).to(beFalse())
        expect(self.view.setIsLoadingItemReceivedArguments?.item.user).to(equal(user))
        
        expect(self.view.showErrorCalled).to(beTrue())
        expect(self.view.showErrorReceivedError).to(matchError(APIError.unknown))
        
        expect(self.moduleOutput.didAcceptFollowRequestCalled).to(beFalse())
    }
    
    func testThatItProcessesCancelPendingRequest() {
        // given
        let user = User()
        let item = FollowRequestItem(user: user)
        
        interactor.rejectPendingRequestToCompletionReturnValue = .success()
        
        // when
        sut.onReject(item)
        
        // then
        expect(self.interactor.rejectPendingRequestToCompletionCalled).to(beTrue())
        
        expect(self.view.setIsLoadingItemCalled).to(beTrue())
        expect(self.view.setIsLoadingItemReceivedArguments?.isLoading).to(beFalse())
        expect(self.view.setIsLoadingItemReceivedArguments?.item.user).to(equal(user))
    }
    
    func testThatItProcessesCancelPendingRequestAndShowsErrorWhenRequestFails() {
        // given
        let user = User()
        let item = FollowRequestItem(user: user)
        
        interactor.rejectPendingRequestToCompletionReturnValue = .failure(APIError.unknown)
        
        // when
        sut.onReject(item)
        
        // then
        expect(self.interactor.rejectPendingRequestToCompletionCalled).to(beTrue())
        
        expect(self.view.setIsLoadingItemCalled).to(beTrue())
        expect(self.view.setIsLoadingItemReceivedArguments?.isLoading).to(beFalse())
        expect(self.view.setIsLoadingItemReceivedArguments?.item.user).to(equal(user))
        
        expect(self.view.showErrorCalled).to(beTrue())
        expect(self.view.showErrorReceivedError).to(matchError(APIError.unknown))
    }
}
