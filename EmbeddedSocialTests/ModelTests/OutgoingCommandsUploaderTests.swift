//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class OutgoingCommandsUploaderTests: XCTestCase {
    var networkTracker: MockNetworkTracker!
    var cache: MockCache!
    var jsonDecoder: MockJSONDecoder.Type!
    var operationsBuilder: MockOutgoingCommandOperationsBuilder.Type!
    var socialService: MockSocialService!
    
    var sut: OutgoingCommandsUploader!
    
    override func setUp() {
        super.setUp()
        
        networkTracker = MockNetworkTracker()
        cache = MockCache()
        jsonDecoder = MockJSONDecoder.self
        operationsBuilder = MockOutgoingCommandOperationsBuilder.self
        socialService = MockSocialService()
        
        sut = OutgoingCommandsUploader(networkTracker: networkTracker,
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
        guard let listener = networkTracker.addListenerReceivedListener as? OutgoingCommandsUploader else {
            XCTFail("Must register listener")
            return
        }
        XCTAssertTrue(listener === sut)
    }
    
    func testThatItCorrectlyStops() {
        // given
        
        // when
        sut.stop()
        
        // then
        XCTAssertTrue(networkTracker.removeListenerCalled)
        guard let listener = networkTracker.removeListenerReceivedListener as? OutgoingCommandsUploader else {
            XCTFail("Must register listener")
            return
        }
        XCTAssertTrue(listener === sut)
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
        
        guard let inputCommand = operationsBuilder.operationForCommandInputCommand as? FollowCommand else {
            XCTFail("Operations builder must receive the correct input command")
            return
        }
        XCTAssertEqual(inputCommand.user, user)
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
