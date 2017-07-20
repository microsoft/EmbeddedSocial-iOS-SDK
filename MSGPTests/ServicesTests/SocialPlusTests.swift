//
//  SocialPlusTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class SocialPlusTests: XCTestCase {
    private let sut = SocialPlus.shared
    
    override func setUp() {
        super.setUp()
        sut.setServiceProviderForTesting(SocialPlusServices())
    }
    
    override func tearDown() {
        super.tearDown()
        sut.setServiceProviderForTesting(SocialPlusServices())
    }
    
    func testThatURLIsOpened() {
        testThatURLIsOpened(withExpectedResult: true)
        testThatURLIsOpened(withExpectedResult: false)
    }
    
    func testThatURLIsOpened(withExpectedResult originalResult: Bool) {
        // given
        let urlSchemeService = MockURLSchemeService(openURLResult: originalResult)
        let socialPlusServicesProvider = MockSocialPlusServices(urlSchemeService: urlSchemeService)
        let url = URL(string: "http://google.com")
        
        // when
        sut.setServiceProviderForTesting(socialPlusServicesProvider)
        
        XCTAssertNotNil(url)
        let actualResult = sut.application(UIApplication.shared, open: url!, options: [:])
        
        // then
        XCTAssertEqual(originalResult, actualResult)
        XCTAssertTrue(urlSchemeService.openURLIsCalled)
    }
}
