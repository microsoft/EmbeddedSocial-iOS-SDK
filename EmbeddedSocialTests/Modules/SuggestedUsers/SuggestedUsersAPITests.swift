//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class SuggestedUsersAPITests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItCallsCorrectServiceAPI() {
        // given
        let socialService = MockSocialService()
        let response = UsersListResponse(items: [], cursor: nil, isFromCache: false)
        socialService.getSuggestedUsersReturnValue = .success(response)
        let sut = SuggestedUsersAPI(socialService: socialService, authorization: UUID().uuidString)
        
        // when
        sut.getUsersList(cursor: nil, limit: 0) { _ in () }
        
        // then
        expect(socialService.getSuggestedUsersCalled).toEventually(beTrue(), timeout: 1.0)
    }
}
