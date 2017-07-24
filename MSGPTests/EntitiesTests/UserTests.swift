//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

class UserTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.set(nil, forKey: className)
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
        let user = User(uid: uid,
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        bio: bio,
                        photo: photo,
                        credentials: credentials)
        
        // then
        XCTAssertEqual(user.uid, uid)
        XCTAssertEqual(user.firstName, firstName)
        XCTAssertEqual(user.lastName, lastName)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.bio, bio)
        XCTAssertEqual(user.photo, photo)
        XCTAssertEqual(user.credentials, credentials)
    }
    
    func testMementoInitialization() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let photo = Photo(url: "http://google.com")
        let user = User(uid: UUID().uuidString,
                        firstName: "First name",
                        lastName: "Last name",
                        email: "email",
                        bio: "This is a test bio",
                        photo: photo,
                        credentials: credentials)
        
        // when
        let loadedUser = User(memento: user.memento)
        
        // then
        XCTAssertNotNil(loadedUser)
        XCTAssertEqual(user, loadedUser!)
    }
    
    func testMementoSerialization() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: "accessToken", socialUID: "socialUID")
        let user = User(uid: "12345",
                        firstName: "First name",
                        lastName: "Last name",
                        email: "test@gmail.com",
                        bio: "This is a test bio",
                        photo: Photo(uid: "54321", url: "http://google.com"),
                        credentials: credentials)
        
        let expectedMemento: Memento = [
            "uid": "12345",
            "firstName": "First name",
            "lastName": "Last name",
            "email": "test@gmail.com",
            "bio": "This is a test bio",
            "photo": ["uid": "54321", "url": "http://google.com"],
            "credentials": [
                "provider": AuthProvider.facebook.rawValue,
                "accessToken": "accessToken",
                "socialUID": "socialUID",
                "appKey": "\(Constants.appKey)"
            ]
        ]
        
        // when
        UserDefaults.standard.set(user.memento, forKey: className)
        let loadedMemento = UserDefaults.standard.object(forKey: className) as? Memento

        // then
        XCTAssertNotNil(loadedMemento)
        XCTAssertTrue((loadedMemento! as NSDictionary).isEqual(to: expectedMemento))
    }
    
    func testUsersAreEqual() {
        // given
        let uid = UUID().uuidString
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let email = UUID().uuidString
        let bio = UUID().uuidString
        let photo = Photo()
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        
        let user1 = User(uid: uid, firstName: firstName, lastName: lastName, email: email,
                         bio: bio, photo: photo, credentials: credentials)
        
        let user2 = User(uid: uid, firstName: firstName, lastName: lastName, email: email,
                         bio: bio, photo: photo, credentials: credentials)
        
        // when
        let areEqual = user1 == user2
        
        // then
        XCTAssertTrue(areEqual)
        assertDumpsEqual(user1, user2)
    }
    
    func testUsersAreNotEqual() {
        // given
        let uid = UUID().uuidString
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let email = UUID().uuidString
        let bio = UUID().uuidString
        let photo = Photo()
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        
        let originalUser = User(uid: uid, firstName: firstName, lastName: lastName, email: email,
                                bio: bio, photo: photo, credentials: credentials)
        
        let modifiedCredentials = CredentialsList(provider: .twitter, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        
        let modifiedUsers = [
            User(uid: uid + "1", firstName: firstName, lastName: lastName, email: email,
                 bio: bio, photo: photo, credentials: credentials),
            
            User(uid: uid, firstName: firstName + "1", lastName: lastName, email: email,
                 bio: bio, photo: photo, credentials: credentials),
            
            User(uid: uid, firstName: firstName, lastName: lastName + "1", email: email,
                 bio: bio, photo: photo, credentials: credentials),
            
            User(uid: uid, firstName: firstName, lastName: lastName, email: email + "1",
                 bio: bio, photo: photo, credentials: credentials),
            
            // modified photo
            User(uid: uid, firstName: firstName, lastName: lastName, email: email,
                 bio: bio, photo: Photo(), credentials: credentials),
            
            // modified credentials
            User(uid: uid, firstName: firstName, lastName: lastName, email: email,
                 bio: bio, photo: photo, credentials: modifiedCredentials)
        ]
        
        // when
        
        // then
        for modifiedUser in modifiedUsers {
            let areEqual = originalUser == modifiedUser
            XCTAssertFalse(areEqual)
            assertDumpsNotEqual(originalUser, modifiedUser)
        }
    }
}
