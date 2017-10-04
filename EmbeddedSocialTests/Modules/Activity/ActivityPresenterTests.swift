//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial


class MockActivityInteractor: ActivityInteractorInput {
    
    //MARK: - loadMyActivities
    
    var loadMyActivitiesCompletionCalled = false
    var loadMyActivitiesResult: ActivityItemListResult!
    
    func loadMyActivities(completion: ((ActivityItemListResult) -> Void)?) {
        loadMyActivitiesCompletionCalled = true
        loadMyActivitiesResult?(loadMyActivitiesResult)
    }
    
    //MARK: - loadNextPageMyActivities
    
    var loadNextPageMyActivitiesCompletionCalled = false
    var loadNextPageMyActivitiesResult: ActivityItemListResult!
    
    func loadNextPageMyActivities(completion: ((ActivityItemListResult) -> Void)?) {
        loadNextPageMyActivitiesCompletionCalled = true
        completion?(loadNextPageMyActivitiesResult)
    }
    
    //MARK: - loadOthersActivities
    
    var loadOthersActivitiesCompletionCalled = false
    var loadOthersActivitiesResult: ActivityItemListResult!
    
    func loadOthersActivities(completion: ((ActivityItemListResult) -> Void)?) {
        loadOthersActivitiesCompletionCalled = true
        completion?(loadOthersActivitiesResult)
    }
    
    //MARK: - loadNextPageOthersActivities
    
    var loadNextPageOthersActivitiesCompletionCalled = false
    var loadNextPageOthersActivitiesResult: ActivityItemListResult!
    
    func loadNextPageOthersActivities(completion: ((ActivityItemListResult) -> Void)?) {
        loadNextPageOthersActivitiesCompletionCalled = true
        completion?(loadNextPageOthersActivitiesResult)
    }
    
    //MARK: - loadPendingRequestItems
    
    var loadPendingRequestItemsCompletionCalled = false
    var loadPendingRequestResult: UserRequestListResult!
    
    func loadPendingRequestItems(completion: ((UserRequestListResult) -> Void)?) {
        loadPendingRequestItemsCompletionCalled = true
        completion?(loadPendingRequestResult)
    }
    
    //MARK: - loadNextPagePendigRequestItems
    
    var loadNextPagePendigRequestItemsCompletionCalled = false
    var loadNextPagePendigRequest: UserRequestListResult!
    
    func loadNextPagePendigRequestItems(completion: ((UserRequestListResult) -> Void)?) {
        loadNextPagePendigRequestItemsCompletionCalled = true
        completion?(loadNextPagePendigRequest)
    }
    
    //MARK: - acceptPendingRequest
    
    var acceptPendingRequestUserCompletionCalled = false
    var acceptPendingRequestUserCompletionReceivedArguments: (user: User, completion: (Result<Void>) -> Void)?
    
    func acceptPendingRequest(user: User, completion: @escaping (Result<Void>) -> Void) {
        acceptPendingRequestUserCompletionCalled = true
        acceptPendingRequestUserCompletionReceivedArguments = (user: user, completion: completion)
    }
    
    //MARK: - rejectPendingRequest
    
    var rejectPendingRequestUserCompletionCalled = false
    var rejectPendingRequestUserCompletionReceivedArguments: (user: User, completion: (Result<Void>) -> Void)?
    
    
    func rejectPendingRequest(user: User, completion: @escaping (Result<Void>) -> Void) {
        rejectPendingRequestUserCompletionCalled = true
        rejectPendingRequestUserCompletionReceivedArguments = (user: user, completion: completion)
    }
    
}

class ActivityPresenterTests: XCTestCase {
    
    var sut: ActivityPresenter!
    var interactor : ActivityInteractorMock!
    var view: ActivityViewMock!
    
    override func setUp() {
        super.setUp()
        
        view = ActivityViewMock()
        sut = ActivityPresenter()
        sut.view = view
        interactor = ActivityInteractorMock()
        sut.interactor = interactor
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    
    func testThatOthersFeedActivityIsCorrect() {
        
    }
    
    // TODO: impl tests for errors

    
}

