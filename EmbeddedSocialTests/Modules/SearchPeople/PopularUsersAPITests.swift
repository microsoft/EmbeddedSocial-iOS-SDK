//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class PopularUsersAPITests: XCTestCase {
    func testThatItCallsCorrectServiceAPI() {
        // given
        let service = MockSocialService()
        service.getPopularUsersReturnValue = .success(UsersListResponse(users: [], cursor: nil, isFromCache: true))
        let api = PopularUsersAPI(socialService: service)
        let cursor = UUID().uuidString
        let limit = Int(arc4random() % 100)
        
        
        // when
        var result: Result<UsersListResponse>?
        api.getUsersList(cursor: cursor, limit: limit) { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil())

        expect(service.getPopularUsersCalled).toEventually(beTrue())
        expect(service.getPopularUsersInputValues?.cursor).toEventually(equal(cursor))
        expect(service.getPopularUsersInputValues?.limit).toEventually(equal(limit))
    }
}
