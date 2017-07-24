//
//  AuthProviderTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class AuthProviderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatNameCorrespondsToProvider() {
        // given
        let expectedNames: [AuthProvider: String] = [
            .facebook: "Facebook",
            .microsoft: "Microsoft",
            .google: "Google",
            .twitter: "Twitter"
        ]
        
        let providers: [AuthProvider] = [.facebook, .microsoft, .google, .twitter]
        
        // when
        
        
        // then
        
        for provider in providers {
            let name = provider.name
            let expectedName = expectedNames[provider]
            XCTAssertEqual(name, expectedName)
        }
    }
}
