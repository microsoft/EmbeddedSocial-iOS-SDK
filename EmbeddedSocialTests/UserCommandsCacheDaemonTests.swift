//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UserCommandsCacheDaemonTests: XCTestCase {
    var networkTracker: MockNetworkTracker!
    var cache: MockCache!
    var jsonDecoder: MockJSONDecoder.Type!
    var operationsBuilder: MockUserCommandOperationsBuilder.Type!
    var socialService: MockSocialService!
    
    var sut: UserCommandsCacheDaemon!
    
    override func setUp() {
        super.setUp()
        
        networkTracker = MockNetworkTracker()
        cache = MockCache()
        jsonDecoder = MockJSONDecoder.self
        operationsBuilder = MockUserCommandOperationsBuilder.self
        socialService = MockSocialService()
        
        sut = UserCommandsCacheDaemon(networkTracker: networkTracker,
                                      cache: cache,
                                      jsonDecoderType: jsonDecoder,
                                      operationsBuilderType: operationsBuilder)
    }
    
    override func tearDown() {
        super.tearDown()
        networkTracker = nil
        cache = nil
        jsonDecoder = nil
        operationsBuilder = nil
        socialService = nil
        sut = nil
    }
    
    func testThatItCorrectlyStarts() {
        // given
        
        // when
        sut.start()
        
        // then
        XCTAssertTrue(jsonDecoder.setupDecodersCalled)
        XCTAssertTrue(networkTracker.addListenerCalled)
    }
    
    func testThatItSubmitsPendingCommandsWhenNetworkBecomesAvailable() {
        // given
        let user = User()
        let command = FollowCommand(user: user)
        operationsBuilder.operationForCommandReturnValue = FollowOperation(command: command, socialService: socialService)
        cache.fetchOutgoing_with_ReturnValue = [command]
        
        // when
        sut.networkStatusDidChange(true)
        
        wait(for: [cache.deleteOutgoing_Expectation], timeout: 1.0)
        
        XCTAssertEqual(socialService.followCount, 1)
        XCTAssertEqual(socialService.followInputUser, user)
        
        XCTAssertTrue(operationsBuilder.operationForCommandCalled)
        XCTAssertEqual(operationsBuilder.operationForCommandInputCommand?.user, user)
    }
    
    func testThatItDoesNothingWhenNetworkBecomesUnavailable() {
        // given
        cache.deleteOutgoing_Expectation.isInverted = true
        
        // when
        sut.networkStatusDidChange(false)
        
        wait(for: [cache.deleteOutgoing_Expectation], timeout: 1.0)
        
        XCTAssertEqual(socialService.followCount, 0)
        XCTAssertFalse(operationsBuilder.operationForCommandCalled)
    }
}














