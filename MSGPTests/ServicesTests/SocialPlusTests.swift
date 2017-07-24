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
        sut.setupServices(with: SocialPlusServices())
    }
    
    override func tearDown() {
        super.tearDown()
        sut.setupServices(with: SocialPlusServices())
    }
    
    func testThatURLIsOpened() {
        testThatURLIsOpened(mockResult: true)
        testThatURLIsOpened(mockResult: false)
    }
    
    func testThatURLIsOpened(mockResult: Bool) {
        // given
        let urlSchemeService = MockURLSchemeService(openURLResult: mockResult)
        let socialPlusServicesProvider = MockSocialPlusServices(urlSchemeService: urlSchemeService)
        let url = URL(string: "http://google.com")
        
        // when
        sut.setupServices(with: socialPlusServicesProvider)
        
        XCTAssertNotNil(url)
        let actualResult = sut.application(UIApplication.shared, open: url!, options: [:])
        
        // then
        XCTAssertEqual(mockResult, actualResult)
        XCTAssertTrue(urlSchemeService.openURLIsCalled)
    }
}
