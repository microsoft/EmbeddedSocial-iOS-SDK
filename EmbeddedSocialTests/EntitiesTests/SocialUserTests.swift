//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SocialUserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        // given
        let uid = UUID().uuidString
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let email = UUID().uuidString
        let bio = UUID().uuidString
        let photo = Photo()
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        
        // when
        let user = SocialUser(uid: uid,
                              credentials: credentials,
                              firstName: firstName,
                              lastName: lastName,
                              email: email,
                              bio: bio,
                              photo: photo)
        
        // then
        XCTAssertEqual(uid, user.uid)
        XCTAssertEqual(firstName, user.firstName)
        XCTAssertEqual(lastName, user.lastName)
        XCTAssertEqual(email, user.email)
        XCTAssertEqual(bio, user.bio)
        XCTAssertEqual(photo, user.photo)
        XCTAssertEqual(credentials, user.credentials)
    }
    
    func testThatUsersAreEqual() {
        // given
        let uid = UUID().uuidString
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let email = UUID().uuidString
        let bio = UUID().uuidString
        let photo = Photo()
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        
        let user1 = SocialUser(uid: uid,
                               credentials: credentials,
                               firstName: firstName,
                               lastName: lastName,
                               email: email,
                               bio: bio,
                               photo: photo)
        
        let user2 = SocialUser(uid: uid,
                               credentials: credentials,
                               firstName: firstName,
                               lastName: lastName,
                               email: email,
                               bio: bio,
                               photo: photo)
        
        // when
        let areEqual = user1 == user2
        
        // then
        XCTAssertTrue(areEqual)
        assertDumpsEqual(user1, user2)
    }
    
    func testThatUsersAreNotEqual() {
        // given
        let uid = UUID().uuidString
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let email = UUID().uuidString
        let bio = UUID().uuidString
        let photo = Photo()
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        
        let originalUser = SocialUser(uid: uid, credentials: credentials, firstName: firstName, lastName: lastName,
                                      email: email, bio: bio, photo: photo)
        
        let modifiedCredentials = CredentialsList(provider: .twitter, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let modifiedUsers = [
            SocialUser(uid: uid + "1", credentials: credentials, firstName: firstName, lastName: lastName,
                       email: email, bio: bio, photo: photo),
            
            SocialUser(uid: uid, credentials: credentials, firstName: firstName + "1", lastName: lastName,
                       email: email, bio: bio, photo: photo),
            
            SocialUser(uid: uid, credentials: credentials, firstName: firstName, lastName: lastName + "1",
                       email: email, bio: bio, photo: photo),
            
            SocialUser(uid: uid, credentials: credentials, firstName: firstName, lastName: lastName,
                       email: email + "1", bio: bio, photo: photo),
            
            SocialUser(uid: uid, credentials: credentials, firstName: firstName, lastName: lastName,
                       email: email, bio: bio + "1", photo: photo),
            
            // modified photo
            SocialUser(uid: uid, credentials: credentials, firstName: firstName, lastName: lastName,
                       email: email, bio: bio, photo: Photo()),
            
            // modified credentials
            SocialUser(uid: uid, credentials: modifiedCredentials, firstName: firstName, lastName: lastName,
                       email: email, bio: bio, photo: photo)
        ]

        // when
        
        // then
        for modifiedUser in modifiedUsers {
            let areEqual = modifiedUser == originalUser
            XCTAssertFalse(areEqual)
            assertDumpsNotEqual(modifiedUser, originalUser)
        }
    }
}
