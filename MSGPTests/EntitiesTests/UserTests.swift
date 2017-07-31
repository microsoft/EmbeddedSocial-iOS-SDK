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
        let uid = UUID().uuidString
        let bio = "This is a test bio"
        let email = "test@mail.com"
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let followersCount = 1
        let followingCount = 2
        let credentials = CredentialsList(provider: .facebook, accessToken: "accessToken", socialUID: "socialUID")
        let photo = Photo(url: "http://google.com")
        let visibility = Visibility._private
        let followerStatus = FollowStatus.accepted
        let followingStatus = FollowStatus.blocked
        
        let user = User(uid: uid,
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        bio: bio,
                        photo: photo,
                        credentials: credentials,
                        followersCount: followersCount,
                        followingCount: followingCount,
                        visibility: visibility,
                        followerStatus: followerStatus,
                        followingStatus: followingStatus)
        
        // when
        let loadedUser = User(memento: user.memento)
        
        // then
        XCTAssertNotNil(loadedUser)
        XCTAssertEqual(user, loadedUser!)
    }
    
    func testMementoSerialization() {
        // given
        let uid = UUID().uuidString
        let bio = "This is a test bio"
        let email = "test@mail.com"
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let followersCount = 1
        let followingCount = 2
        let credentials = CredentialsList(provider: .facebook, accessToken: "accessToken", socialUID: "socialUID")
        let photo = Photo(url: "http://google.com")
        let visibility = Visibility._private
        let followerStatus = FollowStatus.accepted
        let followingStatus = FollowStatus.blocked
        
        let user = User(uid: uid,
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        bio: bio,
                        photo: photo,
                        credentials: credentials,
                        followersCount: followersCount,
                        followingCount: followingCount,
                        visibility: visibility,
                        followerStatus: followerStatus,
                        followingStatus: followingStatus)
        
        let expectedMemento: Memento = [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "bio": bio,
            "photo": photo.memento,
            "credentials": credentials.memento,
            "followersCount": followersCount,
            "followingCount": followingCount,
            "followingStatus": followingStatus.rawValue,
            "followerStatus": followerStatus.rawValue,
            "visibility": visibility.rawValue
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
    
    func testThatUIDAreNotEqual() {
        assertNotEqual(User(uid: UUID().uuidString), User(uid: UUID().uuidString))
    }
    
    func testThatFirstNamesAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, firstName: UUID().uuidString), User(uid: uid, firstName: UUID().uuidString))
    }
    
    func testThatLastNamesAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, lastName: UUID().uuidString), User(uid: uid, lastName: UUID().uuidString))
    }
    
    func testThatEmailsAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, email: UUID().uuidString), User(uid: uid, email: UUID().uuidString))
    }
    
    func testThatBiosAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, bio: UUID().uuidString), User(uid: uid, bio: UUID().uuidString))
    }
    
    func testThatPhotosAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, photo: Photo()), User(uid: uid, photo: Photo()))
    }
    
    func testThatFollowersCountsAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, followersCount: 1), User(uid: uid, followersCount: 2))
    }
    
    func testThatFollowingCountsAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, followingCount: 1), User(uid: uid, followingCount: 2))
    }
    
    func testThatVisibilitiesAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, visibility: ._public), User(uid: uid, visibility: ._private))
    }
    
    func testThatFollowerStatusesAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, followerStatus: .empty), User(uid: uid, followerStatus: .accepted))
    }
    
    func testThatFollowingStatusesAreNotEqual() {
        let uid = UUID().uuidString
        assertNotEqual(User(uid: uid, followingStatus: .empty), User(uid: uid, followingStatus: .accepted))
    }
    
    func testThatCredentialsAreNotEqual() {
        let uid = UUID().uuidString
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let modifiedCredentials = CredentialsList(provider: .twitter, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        assertNotEqual(User(uid: uid, credentials: credentials), User(uid: uid, credentials: modifiedCredentials))
    }
    
    func assertNotEqual(_ lhs: User, _ rhs: User) {
        let areEqual = lhs == rhs
        XCTAssertFalse(areEqual)
        assertDumpsNotEqual(lhs, rhs)
    }
}
