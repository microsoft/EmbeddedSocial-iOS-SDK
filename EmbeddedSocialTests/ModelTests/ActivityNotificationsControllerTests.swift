//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class MockNotificationUpdater: NotificationsUpdater {
    var didCallUpdateNotifications = false
    func updateNotifications() {
        didCallUpdateNotifications = true
    }
}

class ActivityNotificationsControllerTests: XCTestCase {
    
    var sut: ActivityNotificationsController!
    var updater: MockNotificationUpdater!
    
    override func setUp() {
        super.setUp()
        
        sut = ActivityNotificationsController(interval: TimeInterval(1))
        
        updater = MockNotificationUpdater()
        
        sut.notificationUpdater = updater
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNotificationUpdaterWorks() {
        
        sut.start()
        expect(self.updater.didCallUpdateNotifications).toEventually(beTrue(), timeout: 1.001)
        
    }
    
    func testNotificationUpdaterDoNotUpdatesAfterRelease() {
        
        // given
        weak var weakSut = sut
        sut.start()
    
        sut.finish()
        sut = nil
        
        let e = self.expectation(description: "deinit")
        
        DispatchQueue.main.async {
            
            XCTAssertNil(weakSut)
            XCTAssertFalse(self.updater.didCallUpdateNotifications)
            e.fulfill()
        }
        
        wait(for: [e], timeout: 1.001)
    }
    
}
