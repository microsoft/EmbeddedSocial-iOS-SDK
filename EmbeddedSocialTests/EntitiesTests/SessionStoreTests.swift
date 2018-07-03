//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SessionStoreTests: XCTestCase {
    private var database: MockSessionStoreDatabase!
    private var sut: SessionStore!
    
    override func setUp() {
        super.setUp()
        database = MockSessionStoreDatabase()
        sut = SessionStore(database: database)
    }
    
    override func tearDown() {
        super.tearDown()
        database = nil
        sut = nil
    }
    
    func testThatSessionIsLoaded() {
        // given
        let sessionToken = UUID().uuidString
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = User(uid: UUID().uuidString, firstName: UUID().uuidString, lastName: UUID().uuidString,
                        email: UUID().uuidString, bio: UUID().uuidString, photo: Photo(), credentials: credentials)
        
        // when
        database.sessionTokenToReturn = sessionToken
        database.userToReturn = user
        
        do {
            try sut.loadLastSession()
            XCTAssertEqual(sut.user, user)
            XCTAssertEqual(sut.sessionToken, sessionToken)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        // then
        XCTAssertEqual(database.loadUserCount, 1)
        XCTAssertEqual(database.loadSessionTokenCount, 1)
    }
    
    func testThatIsThrowsWhenNoSessionIsLoaded() {
        XCTAssertThrows(expression: try sut.loadLastSession(), error: SessionStore.Error.lastSessionNotAvailable)
    }
    
    func testThatItIsNotLoggedIn() {
        XCTAssertFalse(sut.isLoggedIn)
    }
    
    func testThatItIsLoggedIn() {
        // given
        let sessionToken = UUID().uuidString
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = User(uid: UUID().uuidString, firstName: UUID().uuidString, lastName: UUID().uuidString,
                        email: UUID().uuidString, bio: UUID().uuidString, photo: Photo(), credentials: credentials)
        
        // when
        database.sessionTokenToReturn = sessionToken
        database.userToReturn = user
        XCTAssertNoThrow(try sut.loadLastSession())
        
        // then
        XCTAssertTrue(sut.isLoggedIn)
    }
    
    func testThatItThrowsWhenSavingSessionBeingNotLoggedIn() {
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertThrows(expression: try sut.saveCurrentSession(), error: SessionStore.Error.notLoggedIn)
    }
    
    func testThatItSavesSession() {
        // given
        let sessionToken = UUID().uuidString
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = User(uid: UUID().uuidString, firstName: UUID().uuidString, lastName: UUID().uuidString,
                        email: UUID().uuidString, bio: UUID().uuidString, photo: Photo(), credentials: credentials)
        
        // when
        database.sessionTokenToReturn = sessionToken
        database.userToReturn = user
        XCTAssertNoThrow(try sut.loadLastSession())

        // then
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertNoThrow(try sut.saveCurrentSession())
    }
    
    func testErrorDescriptionExists() {
        // given
        let errors: [SessionStore.Error] = [.notLoggedIn, .lastSessionNotAvailable]
        
        // when
        let descriptions = errors.flatMap { $0.errorDescription }
        
        // then
        XCTAssertEqual(errors.count, descriptions.count)
    }
    
    func testThatAuthorizationIsCorrectForAnonymousUser() {
        XCTAssertEqual(sut.authorization, Authorization.anonymous)
    }
    
    func testThatAuthorizationIsCorrectForLoggedInUser() {
        // given
        let sessionToken = UUID().uuidString
        let user = User()
        
        // when
        sut.createSession(withUser: user, sessionToken: sessionToken)
        
        // then
        XCTAssertEqual(sut.authorization, Constants.API.authorization(sessionToken))
    }
}
