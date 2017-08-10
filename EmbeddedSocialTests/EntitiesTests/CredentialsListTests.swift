//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

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
    
    func testThatFacebookAuthHeaderIsCorrect() {
        // given
        let accessToken = UUID().uuidString
        let provider: AuthProvider = .facebook
        let appKey = UUID().uuidString
        let credentials = CredentialsList(provider: provider, accessToken: accessToken, socialUID: UUID().uuidString, appKey: appKey)
        
        let expectedAuthorization = Authorization(format: "%@ AK=%@|TK=%@", provider.name, appKey, accessToken)
        
        // when
        let authorization = credentials.authorization
        
        // then
        XCTAssertEqual(authorization, expectedAuthorization)
    }
    
    func testThatGoogleAuthHeaderIsCorrect() {
        // given
        let accessToken = UUID().uuidString
        let provider: AuthProvider = .google
        let appKey = UUID().uuidString
        let credentials = CredentialsList(provider: provider, accessToken: accessToken, socialUID: UUID().uuidString, appKey: appKey)
        
        let expectedAuthorization = Authorization(format: "%@ AK=%@|TK=%@", provider.name, appKey, accessToken)
        
        // when
        let authorization = credentials.authorization
        
        // then
        XCTAssertEqual(authorization, expectedAuthorization)
    }
    
    func testThatAuthHeaderIsCorrect() {
        // given
        let parameters: [AuthProvider: [String: Any]] = [
            AuthProvider.facebook: ["accessToken": UUID().uuidString, "appKey": UUID().uuidString],
            AuthProvider.google: ["accessToken": UUID().uuidString, "appKey": UUID().uuidString],
            AuthProvider.microsoft: ["accessToken": UUID().uuidString, "appKey": UUID().uuidString],
            AuthProvider.twitter: ["accessToken": UUID().uuidString, "appKey": UUID().uuidString, "requestToken": UUID().uuidString]
        ]
        
        var expectedAuthorizations: [AuthProvider: Authorization] = [:]
        
        for pair in parameters {
            let requestToken = pair.value["requestToken"] as? String
            let appKey = pair.value["appKey"] as! String
            let token = pair.value["accessToken"] as! String
            
            expectedAuthorizations[pair.key] = requestToken == nil ?
                "\(pair.key.name) AK=\(appKey)|TK=\(token)" :
                "\(pair.key.name) AK=\(appKey)|RT=\(requestToken!)|TK=\(token)"
        }
        
        // when
        var actualAuthorizations: [AuthProvider: Authorization] = [:]
        
        for pair in parameters {
            let credentials = CredentialsList(provider: pair.key,
                                              accessToken: pair.value["accessToken"] as! String,
                                              requestToken: pair.value["requestToken"] as? String,
                                              socialUID: UUID().uuidString,
                                              appKey: pair.value["appKey"] as! String)
            
            actualAuthorizations[pair.key] = credentials.authorization
        }
        
        // then
        XCTAssertTrue(NSDictionary(dictionary: expectedAuthorizations).isEqual(to: actualAuthorizations))
    }
}
