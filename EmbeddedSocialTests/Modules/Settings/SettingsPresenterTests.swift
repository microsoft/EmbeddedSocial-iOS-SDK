//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SettingsPresenterTests: XCTestCase {
    var router: MockSettingsRouter!
    var sut: SettingsPresenter!
    
    override func setUp() {
        super.setUp()
        router = MockSettingsRouter()
        sut = SettingsPresenter()
        sut.router = router
    }
    
    override func tearDown() {
        super.tearDown()
        router = nil
        sut = nil
    }
    
    func testThatBlockedUsersListIsOpened() {
        sut.onBlockedList()
        XCTAssertEqual(router.openBlockedListCount, 1)
    }
}
