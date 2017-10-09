//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class UsersListResponseProcessorTests: XCTestCase {
    
    var cache: MockCache!
    var operationsBuilder: MockOutgoingCommandOperationsBuilder!
    var predicateBuilder: MockOutgoingCommandsPredicateBuilder!
    private var sut: UsersListResponseProcessor!
    
    override func setUp() {
        super.setUp()
        cache = MockCache()
        operationsBuilder = MockOutgoingCommandOperationsBuilder()
        predicateBuilder = MockOutgoingCommandsPredicateBuilder()
        sut = UsersListResponseProcessor(cache: cache, operationsBuilder: operationsBuilder, predicateBuilder: predicateBuilder)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cache = nil
        operationsBuilder = nil
        predicateBuilder = nil
    }
    
    func testThatItDoesNotModifyIsFromCacheValue() {
        testThatItDoesNotModifyIsFromCacheValue(isFromCache: true)
        testThatItDoesNotModifyIsFromCacheValue(isFromCache: false)
    }
    
    func testThatItDoesNotModifyIsFromCacheValue(isFromCache: Bool) {
        // given
        operationsBuilder.fetchCommandsOperationPredicateReturnValueMaker = {
            MockFetchOutgoingCommandsOperation(cache: self.cache, predicate: NSPredicate())
        }
        cache.fetchOutgoing_with_ReturnValue = []
        var result: Result<UsersListResponse>?
        
        predicateBuilder.allUserCommandsReturnValue = NSPredicate()

        // when
        sut.process(FeedResponseUserCompactView(), isFromCache: isFromCache) { result = $0  }
        
        // then
        expect(result?.value?.isFromCache).toEventually(equal(isFromCache))
    }
    
    func testThatItCorrectlyAppliesCommands() {
        // given
        let user1 = User()
        let command1 = MockUserCommand(user: user1)
        
        let user2 = User()
        let command2 = MockUserCommand(user: user2)
        
        let operation = MockFetchOutgoingCommandsOperation(cache: cache, predicate: NSPredicate())
        operation.setCommands([command1, command2])
        
        cache.fetchOutgoing_with_ReturnValue = [command1, command2]
        
        let response = UsersListResponse(items: [user1, user2], cursor: nil, isFromCache: true)
        
        // when
        _ = sut.apply(commands: [command1, command2], to: response)
        
        // then
        expect(command1.applyCalled).toEventually(beTrue())
        expect(command1.applyInputUser).toEventually(equal(user1))
        
        expect(command2.applyCalled).toEventually(beTrue())
        expect(command2.applyInputUser).toEventually(equal(user2))
    }
    
    func testThatItCorrectlyTransformsResponse() {
        // given
        let userView1 = UserCompactView()
        userView1.userHandle = UUID().uuidString
        
        let userView2 = UserCompactView()
        userView2.userHandle = UUID().uuidString
        
        let response = FeedResponseUserCompactView()
        response.data = [userView1, userView2]
        
        cache.fetchOutgoing_with_ReturnValue = []
        
        operationsBuilder.fetchCommandsOperationPredicateReturnValueMaker = {
            MockFetchOutgoingCommandsOperation(cache: self.cache, predicate: NSPredicate())
        }
        
        predicateBuilder.allUserCommandsReturnValue = NSPredicate()
        
        var result: Result<UsersListResponse>?

        // when
        sut.process(response, isFromCache: true) { result = $0  }
        
        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.value?.isFromCache).toEventually(beTrue())
    }
}
