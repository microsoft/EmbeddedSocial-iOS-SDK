//
//  AuthAPIProviderTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/19/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class AuthAPIProviderTests: XCTestCase {
    
    private var sut: AuthAPIProvider!
    
    override func setUp() {
        super.setUp()
        sut = AuthAPIProvider()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatCorrectAPIInstanceIsReturned() {
        // given
        let providers = AuthProvider.all
        
        // when
        var providerTypes: [AuthProvider: String] = [:]
        
        for provider in providers {
            let instance = sut.api(for: provider)
            let type = type(of: instance)
            providerTypes[provider] = String(describing: type)
        }
        
        // then
        let mustBe: [AuthProvider: String] = [
            .facebook: "FacebookAPI",
            .twitter: "TwitterWebBasedAPI",
            .google: "GoogleAPI",
            .microsoft: "MicrosoftLiveAPI"
        ]
        XCTAssertEqual(providerTypes, mustBe)
    }
}
