//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class OutgoingCommandsUploaderTests: XCTestCase {
    var networkTracker: MockNetworkTracker!
    var jsonDecoder: MockJSONDecoder.Type!
    var strategy: MockOutgoingCommandsUploadStrategy!
    
    var sut: OutgoingCommandsUploader!
    
    override func setUp() {
        super.setUp()
        
        networkTracker = MockNetworkTracker()
        jsonDecoder = MockJSONDecoder.self
        strategy = MockOutgoingCommandsUploadStrategy()
        
        sut = OutgoingCommandsUploader(networkTracker: networkTracker, uploadStrategy: strategy, jsonDecoderType: jsonDecoder)
    }
    
    override func tearDown() {
        super.tearDown()
        networkTracker = nil
        jsonDecoder = nil
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
        
        XCTAssertTrue(strategy.cancelSubmissionCalled)
    }
    
    func testThatItSubmitsPendingCommandsWhenNetworkBecomesAvailable() {
        // given
        
        // when
        sut.networkStatusDidChange(true)
        
        // then
        XCTAssertTrue(strategy.restartSubmissionCalled)
    }
    
    func testThatItDoesNothingWhenNetworkBecomesUnavailable() {
        // given
        
        // when
        sut.networkStatusDidChange(false)
        
        XCTAssertFalse(strategy.restartSubmissionCalled)
    }
}
