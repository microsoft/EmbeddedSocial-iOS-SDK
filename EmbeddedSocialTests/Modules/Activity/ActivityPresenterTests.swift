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
        sut.interactor = ActivityInteractorMock()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test() {
        
        // given
        
        let mockItems = Array(1..<5).map { PendingRequestItem.mock(seed: $0) }
        let result: Result<[PendingRequestItem]> = .success(mockItems)
        
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(model: header, items: [])
        let pendingRequestsDataSource = MyPendingRequests(interactor: interactor,
                                                          section: section)
        
        interactor.pendingRequestsItemsResult = result
        
        pendingRequestsDataSource.loadMore()
        
        pendingRequestsDataSource.section.items.count
        
        
        
    }
    
}

