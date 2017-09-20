//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ActivityInteractorMock: ActivityInteractorInput {
    
    var followingActivityItemsResult: Result<[ActionItem]>!
    var pendingRequestsItemsResult: Result<[PendingRequestItem]>!
    
    func loadAll() {
        
    }
    
    func loadNextPageFollowingActivities(completion: ((Result<[ActionItem]>) -> Void)? = nil) {
        completion?(followingActivityItemsResult)
    }
    
    func loadNextPagePendigRequestItems(completion: ((Result<[PendingRequestItem]>) -> Void)? = nil) {
        completion?(pendingRequestsItemsResult)
    }
    
}

class ActivityPresenterTests: XCTestCase {
    
    var sut: ActivityPresenter!
    var interactor : ActivityInteractorMock!
    
    
    override func setUp() {
        super.setUp()
        
        sut = ActivityPresenter()
        interactor = ActivityInteractorMock()
        sut.interactor = interactor
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatPedningDataSourceReturnsCorrectItems() {
        
        // given
        let itemsMock = Array(1..<5).map { PendingRequestItem.mock(seed: $0) }
        let resultMock: Result<[PendingRequestItem]> = .success(itemsMock)
        
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(model: header, items: [])
        
        let dataSource = MyPendingRequests(interactor: interactor, section: section)
        
        interactor.pendingRequestsItemsResult = resultMock
        
        // when
        dataSource.loadMore()
        
        // then
        XCTAssertTrue(dataSource.section.items.count == itemsMock.count)
    }
    
    func testThatMyFollowingActivityDataSourceReturnsCorrectItems() {
        
        // given
        let itemsMock = Array(1..<5).map { ActionItem.mock(seed: $0) }
        let resultMock: Result<[ActionItem]> = .success(itemsMock)
        
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(model: header, items: [])
        let dataSource = MyFollowingsActivity(interactor: interactor, section: section)
        
        interactor.followingActivityItemsResult = resultMock
        
        // when
        dataSource.loadMore()
        
        // then
        XCTAssertTrue(dataSource.section.items.count == itemsMock.count)
    }
    

    
}

