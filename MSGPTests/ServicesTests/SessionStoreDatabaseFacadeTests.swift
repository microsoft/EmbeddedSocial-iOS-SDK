//
//  SessionStoreDatabaseFacadeTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class SessionStoreDatabaseFacadeTests: XCTestCase {
    private var userRepo: MockKeyValueRepository<User>!
    private var sessionTokenRepo: MockKeyValueRepository<String>!
    private var provider: MockSessionStoreRepositoryProvider!
    private var sut: SessionStoreDatabaseFacade!
    
    override func setUp() {
        super.setUp()
        userRepo = MockKeyValueRepository()
        sessionTokenRepo = MockKeyValueRepository()
        provider = MockSessionStoreRepositoryProvider(userRepository: userRepo, sessionTokenRepository: sessionTokenRepo)
        sut = SessionStoreDatabaseFacade(services: provider)
    }
    
    override func tearDown() {
        super.tearDown()
        provider = nil
        userRepo = nil
        sessionTokenRepo = nil
        sut = nil
    }
    
    func testThatUserIsSaved() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = User(uid: UUID().uuidString, firstName: UUID().uuidString, lastName: UUID().uuidString,
                        email: UUID().uuidString, bio: UUID().uuidString, photo: Photo(), credentials: credentials)
        
        // when
        sut.saveUser(user)
        
        // then
        XCTAssertEqual(userRepo.saveCount, 1)
    }
    
    func testThatUserIsLoaded() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = User(uid: UUID().uuidString, firstName: UUID().uuidString, lastName: UUID().uuidString,
                        email: UUID().uuidString, bio: UUID().uuidString, photo: Photo(), credentials: credentials)
        
        // when
        userRepo.mementoToLoad = user.memento
        sut.saveUser(user)
        let loadedUser = sut.loadLastUser()
        
        // then
        XCTAssertNotNil(loadedUser)
        XCTAssertEqual(user, loadedUser!)
        XCTAssertEqual(userRepo.saveCount, 1)
        XCTAssertEqual(userRepo.loadCount, 1)
    }
    
    func testThatSessionTokenIsSaved() {
        // given
        let sessionToken = UUID().uuidString
        
        // when
        sut.saveSessionToken(sessionToken)
        
        // then
        XCTAssertEqual(sessionTokenRepo.saveCount, 1)
    }
    
    func testThatSessionTokenIsLoaded() {
        // given
        let sessionToken = UUID().uuidString
        
        // when
        sessionTokenRepo.mementoToLoad = sessionToken.memento
        sut.saveSessionToken(sessionToken)
        let loadedSessionToken = sut.loadLastSessionToken()
        
        // then
        XCTAssertNotNil(loadedSessionToken)
        XCTAssertEqual(sessionToken, loadedSessionToken!)
        XCTAssertEqual(sessionTokenRepo.saveCount, 1)
        XCTAssertEqual(sessionTokenRepo.loadCount, 1)
    }
}
