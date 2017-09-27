//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class UsersListResponseProcessorTests: XCTestCase {
    
    var cache: MockCache!
    var builder: MockFetchUserCommandsOperationBuilder!
    var sut: UsersListResponseProcessor!
    
    override func setUp() {
        super.setUp()
        cache = MockCache()
        builder = MockFetchUserCommandsOperationBuilder()
        sut = UsersListResponseProcessor(cache: cache, operationsBuilder: builder)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cache = nil
        builder = nil
    }
    
    func testThatItDoesNotModifyIsFromCacheValue() {
        testThatItDoesNotModifyIsFromCacheValue(isFromCache: true)
        testThatItDoesNotModifyIsFromCacheValue(isFromCache: false)
    }
    
    func testThatItDoesNotModifyIsFromCacheValue(isFromCache: Bool) {
        // given
        builder.makeFetchUserCommandsOperationCacheReturnValue = MockFetchUserCommandsOperation(cache: cache)
        cache.fetchOutgoing_with_ReturnValue = []
        var result: Result<UsersListResponse>?
        
        // when
        sut.process(FeedResponseUserCompactView(), isFromCache: isFromCache) { result = $0  }
        
        // then
        expect(result?.value?.isFromCache).toEventually(equal(isFromCache))
    }
    
    func testThatItCorrectlyAppliesCommands() {
        // given
        let userView1 = UserCompactView()
        userView1.userHandle = UUID().uuidString
        
        let userView2 = UserCompactView()
        userView2.userHandle = UUID().uuidString
        
        let response = FeedResponseUserCompactView()
        response.data = [userView1, userView2]
        
        let user1 = User(compactView: userView1)
        let command1 = MockUserCommand(user: user1)
        
        let user2 = User(compactView: userView2)
        let command2 = MockUserCommand(user: user2)
        
        let operation = MockFetchUserCommandsOperation(cache: cache)
        operation.setCommands([command1, command2])
        
        cache.fetchOutgoing_with_ReturnValue = [command1, command2]
        
        builder.makeFetchUserCommandsOperationCacheReturnValue = operation
        
        var result: Result<UsersListResponse>?

        // when
        sut.process(response, isFromCache: true) { result = $0  }
        
        // then
        expect(result).toEventuallyNot(beNil())
        
        expect(command1.applyCalled).toEventually(beTrue())
        expect(command1.applyInputUser).toEventually(equal(user1))
        
        expect(command2.applyCalled).toEventually(beTrue())
        expect(command2.applyInputUser).toEventually(equal(user2))
    }
}
