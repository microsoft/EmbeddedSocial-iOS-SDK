//
//  FollowStatusTests.swift
//  EmbeddedSocial
//
//  Created by Vadim Bulavin on 7/31/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import EmbeddedSocial

class FollowStatusTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItReducesStateCorrectly() {
        XCTAssertEqual(FollowStatus.reduce(status: .empty, visibility: ._public), .accepted)
        XCTAssertEqual(FollowStatus.reduce(status: .empty, visibility: ._private), .pending)
        
        XCTAssertEqual(FollowStatus.reduce(status: .accepted, visibility: ._public), .empty)
        XCTAssertEqual(FollowStatus.reduce(status: .accepted, visibility: ._private), .empty)
        
        XCTAssertEqual(FollowStatus.reduce(status: .blocked, visibility: ._public), .empty)
        XCTAssertEqual(FollowStatus.reduce(status: .blocked, visibility: ._private), .empty)
        
        XCTAssertEqual(FollowStatus.reduce(status: .pending, visibility: ._public), .empty)
        XCTAssertEqual(FollowStatus.reduce(status: .pending, visibility: ._private), .empty)
    }
    
    func testThatItInitializesFromFollowerStatus() {
        XCTAssertEqual(FollowStatus(status: Optional<UserProfileView.FollowerStatus>.none), .empty)
        
        XCTAssertEqual(FollowStatus(status: UserProfileView.FollowerStatus._none), .empty)
        
        XCTAssertEqual(FollowStatus(status: UserProfileView.FollowerStatus.follow), .accepted)
        
        XCTAssertEqual(FollowStatus(status: UserProfileView.FollowerStatus.pending), .pending)
        
        XCTAssertEqual(FollowStatus(status: UserProfileView.FollowerStatus.blocked), .blocked)
    }
    
    func testThatItInitializesFromFollowingStatus() {
        XCTAssertEqual(FollowStatus(status: Optional<UserProfileView.FollowingStatus>.none), .empty)
        
        XCTAssertEqual(FollowStatus(status: UserProfileView.FollowingStatus._none), .empty)
        
        XCTAssertEqual(FollowStatus(status: UserProfileView.FollowingStatus.follow), .accepted)
        
        XCTAssertEqual(FollowStatus(status: UserProfileView.FollowingStatus.pending), .pending)
        
        XCTAssertEqual(FollowStatus(status: UserProfileView.FollowingStatus.blocked), .blocked)
    }
}
