//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class MockDataSourceDelegate: DataSourceDelegate {
    
    var wasFailed: Error?
    func didFail(error: Error) {
        wasFailed = error
    }
    
    var wasChanged: Array<Change<IndexPath>> = []
    func didChangeItems(change: Change<IndexPath>, context: DataSourceContext) {
        wasChanged.append(change)
    }
    
}

class ActivityDataSourceTests: XCTestCase {
    
    var interactor: MockActivityInteractor!
    var header: SectionHeader!
    var dataSourceDelegate: MockDataSourceDelegate!
    let ctx = DataSourceContext(ActivityPresenter.State.my, 0)
    var activities: [ActivityView]!
    var myActivityDS: MyActivities!

    override func setUp() {
        super.setUp()
        
        interactor = MockActivityInteractor()
        header = SectionHeader(name: L10n.Activity.Sections.Pending.title, identifier: "")
        dataSourceDelegate = MockDataSourceDelegate()
        let response: FeedResponseActivityView = loadResponse(from: "myActivity")!
        activities = response.data!
        XCTAssert(activities.count > 0)
        
        myActivityDS = DataSourceBuilder.buildMyActivitiesDataSource(interactor: interactor,
                                                               delegate: dataSourceDelegate,
                                                               context: ctx)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPageGetsLoaded() {
        
        // given
        let result: ActivityItemListResult = .success(ListResponse(items: activities, cursor: nil, isFromCache: false))
        
        interactor.loadMyActivitiesResult = result
        
        // when
        myActivityDS.load()
        
        XCTAssert(myActivityDS.section.items.count ==  activities.count)
        XCTAssert(myActivityDS.section.pages.count == 1)
        XCTAssert(myActivityDS.section.pages.first!.count == activities.count)
        
        // then
        if case let .insertion(items) = dataSourceDelegate.wasChanged.last! {
            XCTAssert(items.count == activities.count)
        } else {
            XCTFail()
        }
    }
    
    func testPageGetsLoadedMore() {
        
        // given
        let result: ActivityItemListResult = .success(ListResponse(items: activities, cursor: nil, isFromCache: false))
        interactor.loadNextPageMyActivitiesResult = result
        
        let initialItemsSize = 1
        let activityView = ActivityView()
        let header = SectionHeader(name: "", identifier: "")
        let page = [ActivityItem.myActivity(activityView)]
        let section = Section(header: header, pages: [page])
        
        let sut = MyActivities(interactor: interactor, section: section, context: ctx)
        
        XCTAssert(sut.section.pages.count == 1)
        XCTAssert(sut.section.items.count == initialItemsSize)
        
        // when
        sut.loadMore()
        
        // then
        XCTAssert(sut.section.pages.count == 2)
        XCTAssert(sut.section.items.count == (initialItemsSize + activities.count))
    }
    
    func testsCachedPageGetsMergedWithFetchedResult() {
        
        // given
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(header: header, pages: [])
        
        let sut = MyActivities(interactor: interactor, section: section, context: ctx)
        sut.delegate = dataSourceDelegate
        
        let cachedActivities = [ActivityView(), ActivityView(), ActivityView(), ActivityView(), ActivityView()]
        let fetchedActivities = [ActivityView(), ActivityView(), ActivityView()]
        
        let shouldInsertItems = cachedActivities.count
        let shouldRemovedItems = cachedActivities.count - fetchedActivities.count
        let shouldUpdateItems = fetchedActivities.count
        
        let cachedResult: ActivityItemListResult = .success(ListResponse(items: cachedActivities,
                                                                         cursor: nil,
                                                                         isFromCache: true))
        let fetchResult: ActivityItemListResult = .success(ListResponse(items: fetchedActivities,
                                                                        cursor: nil,
                                                                        isFromCache: false))
        interactor.loadMyActivitiesResult = fetchResult
        interactor.loadMyActivitiesResultCached = cachedResult
        
        // when
        sut.load()
        
        // then
        XCTAssert(sut.section.items.count == fetchedActivities.count)
        
        for change in dataSourceDelegate.wasChanged {
            switch change {
            case let .insertion(inserted):
                XCTAssert(inserted.count == shouldInsertItems)
            case let .deletion(deleted):
                XCTAssert(deleted.count == shouldRemovedItems)
            case let .update(updated):
                XCTAssert(updated.count == shouldUpdateItems)
            default:
                XCTFail()
            }
        }

    }
    
    
    
}
