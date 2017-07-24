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
        UserDefaults.standard.set(nil, forKey: className)
    }
    
    func testInitialization() {
        // given
        let provider = AuthProvider.facebook
        let accessToken = UUID().uuidString
        let socialUID = UUID().uuidString
        let appKey = UUID().uuidString
        let requestToken = UUID().uuidString
        
        // when
        let credentials = CredentialsList(provider: provider,
                                          accessToken: accessToken,
                                          requestToken: requestToken,
                                          socialUID: socialUID,
                                          appKey: appKey)
        
        // then
        XCTAssertEqual(provider, credentials.provider)
        XCTAssertEqual(accessToken, credentials.accessToken)
        XCTAssertEqual(requestToken, credentials.requestToken)
        XCTAssertEqual(socialUID, credentials.socialUID)
        XCTAssertEqual(appKey, credentials.appKey)
    }
    
    func testMementoInitialization() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        
        // when
        let loadedCredentials = CredentialsList(memento: credentials.memento)
        
        // then
        XCTAssertNotNil(loadedCredentials)
        XCTAssertEqual(credentials, loadedCredentials!)
    }
    
    func testMementoSerialization() {
        // given
        let provider = AuthProvider.facebook
        let accessToken = UUID().uuidString
        let socialUID = UUID().uuidString
        let appKey = UUID().uuidString
        let requestToken = UUID().uuidString
        let credentials = CredentialsList(provider: provider,
                                          accessToken: accessToken,
                                          requestToken: requestToken,
                                          socialUID: socialUID,
                                          appKey: appKey)
        
        let expectedMemento: Memento = [
            "provider": provider.rawValue,
            "accessToken": accessToken,
            "requestToken": requestToken,
            "appKey": appKey,
            "socialUID": socialUID
        ]
        
        // when
        UserDefaults.standard.set(credentials.memento, forKey: className)
        guard let loadedMemento = UserDefaults.standard.object(forKey: className) as? Memento else {
            XCTFail("Memento not loaded")
            return
        }
        let loadedCredentials = CredentialsList(memento: loadedMemento)
        
        // then
        XCTAssertTrue((loadedMemento as NSDictionary).isEqual(to: expectedMemento))
        XCTAssertEqual(loadedCredentials, credentials)
    }
    
    func testThatCredentialsAreEqual() {
        // given
        let provider = AuthProvider.facebook
        let accessToken = UUID().uuidString
        let socialUID = UUID().uuidString
        let appKey = UUID().uuidString
        let requestToken = UUID().uuidString
        
        let credentials1 = CredentialsList(provider: provider,
                                           accessToken: accessToken,
                                           requestToken: requestToken,
                                           socialUID: socialUID,
                                           appKey: appKey)
        
        let credentials2 = CredentialsList(provider: provider,
                                           accessToken: accessToken,
                                           requestToken: requestToken,
                                           socialUID: socialUID,
                                           appKey: appKey)
        
        // when
        let areEqual = credentials1 == credentials2
        
        // then
        XCTAssertTrue(areEqual)
        assertDumpsEqual(credentials1, credentials2)
    }
    
    func testThatCredentialsAreNotEqual() {
        // given
        let provider = AuthProvider.facebook
        let accessToken = UUID().uuidString
        let socialUID = UUID().uuidString
        let appKey = UUID().uuidString
        let requestToken = UUID().uuidString
        
        let originalCredential = CredentialsList(provider: provider,
                                                 accessToken: accessToken,
                                                 requestToken: requestToken,
                                                 socialUID: socialUID,
                                                 appKey: appKey)
        
        let modifiedCredentials = [
            CredentialsList(provider: .twitter, accessToken: accessToken, requestToken: requestToken,
                            socialUID: socialUID, appKey: appKey),
            
            CredentialsList(provider: provider, accessToken: accessToken + "1", requestToken: requestToken,
                            socialUID: socialUID, appKey: appKey),
            
            CredentialsList(provider: provider, accessToken: accessToken, requestToken: requestToken + "1",
                            socialUID: socialUID, appKey: appKey),
            
            CredentialsList(provider: provider, accessToken: accessToken, requestToken: requestToken,
                            socialUID: socialUID + "1", appKey: appKey),
            
            CredentialsList(provider: provider, accessToken: accessToken, requestToken: requestToken,
                            socialUID: socialUID, appKey: appKey + "1")
        ]
        // when
        
        // then
        for modifiedCredential in modifiedCredentials {
            let areEqual = originalCredential == modifiedCredential
            XCTAssertFalse(areEqual)
            assertDumpsNotEqual(originalCredential, modifiedCredential)
        }
    }
    
}
