//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ActivityInteractorMock: ActivityInteractorInput, DataSourceDelegate {
    
    var didLoadPaths: [IndexPath]?
    
    func didFail(error: Error) {
        
    }
    
    func didLoad(indexPaths: [IndexPath]) {
        didLoadPaths = indexPaths
    }
    
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

class ActivityViewMock: ActivityViewInput {
    
    func setupInitialState() {
        
    }
    
    func registerCell(cell: UITableViewCell.Type, id: String) {
        
    }
    
    func showError(_ error: Error) {
        
    }
    
    func addNewItems(indexes: [IndexPath]) {
        
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
    
    func testThatPedningDataSourceReturnsCorrectItems() {
        
        // given
        let randomSectionIndex = Int(arc4random() % 5)
        let itemsMockCount = Int(arc4random() % 10) + 1
        let itemsMock = Array(0..<itemsMockCount).map { PendingRequestItem.mock(seed: $0) }
        let resultMock: Result<[PendingRequestItem]> = .success(itemsMock)
        
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(model: header, items: [])
        
        let dataSource = MyPendingRequests(interactor: interactor,
                                           section: section,
                                           delegate: interactor,
                                           index: randomSectionIndex)
        
        interactor.pendingRequestsItemsResult = resultMock
        
        // when
        dataSource.loadMore()
        
        // then
        XCTAssertTrue(dataSource.section.items.count == itemsMockCount)
        XCTAssertTrue(interactor.didLoadPaths?.count == itemsMockCount)
        for (index, path) in interactor.didLoadPaths!.enumerated() {
            XCTAssertTrue(path.section == randomSectionIndex)
        }
    }
    
    func testThatMyFollowingActivityDataSourceReturnsCorrectItems() {
        
        // given
        let itemsMock = Array(1..<5).map { ActionItem.mock(seed: $0) }
        let resultMock: Result<[ActionItem]> = .success(itemsMock)
        
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(model: header, items: [])
        let dataSource = MyFollowingsActivity(interactor: interactor, section: section, index: 0)
        
        interactor.followingActivityItemsResult = resultMock
        
        // when
        dataSource.loadMore()
        
        // then
        XCTAssertTrue(dataSource.section.items.count == itemsMock.count)
    }
    
    func testThatMyFeedActivityIsCorrect() {
        
        // given
        
        let itemsCountA = Int(arc4random() % 10) + 1
        let itemsMockA = Array(0..<itemsCountA).map { PendingRequestItem.mock(seed: $0) }
        let resultMockA: Result<[PendingRequestItem]> = .success(itemsMockA)
        interactor.pendingRequestsItemsResult = resultMockA
        
        let itemsCountB = Int(arc4random() % 10) + 1
        let itemsMockB = Array(0..<itemsCountB).map { ActionItem.mock(seed: $0) }
        let resultMockB: Result<[ActionItem]> = .success(itemsMockB)
        interactor.followingActivityItemsResult = resultMockB
        
        
        // when
        sut.state = .my
        sut.loadMore()
        
        XCTAssertTrue(sut.numberOfSections() == 2, "must be 2 sections for my feed")
        XCTAssertTrue(sut.numberOfItems(in: 0) == itemsCountA)
        XCTAssertTrue(sut.numberOfItems(in: 1) == itemsCountB)
    }
    
    
    
    func testThatOthersFeedActivityIsCorrect() {
        
    }
    
    // TODO: impl tests for errors

    
}

