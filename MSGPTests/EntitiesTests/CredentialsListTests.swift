//
//  CredentialsListTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class CredentialsListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMementoSerialization() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        
        // when
        let loadedCredentials = CredentialsList(memento: credentials.memento)
        
        // then
        XCTAssertNotNil(loadedCredentials)
        XCTAssertEqual(credentials, loadedCredentials!)
    }
}
