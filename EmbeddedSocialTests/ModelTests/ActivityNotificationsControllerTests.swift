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
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTimerFires() {
        let sut = ActivityNotificationsController(interval: TimeInterval(1))
        let updater = MockNotificationUpdater()
        sut.notificationUpdater = updater
    
        expect(updater.didCallUpdateNotifications).toEventually(beTrue(), timeout: 1.001)
    }
}
