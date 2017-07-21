//
//  UserTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class UserTests: XCTestCase {
    private var user: User!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.set(nil, forKey: "UserTests")
    }
    
    func testMementoMapping() {
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
    
    func testThatMementoPropertyListSerialization() {
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
        UserDefaults.standard.set(user.memento, forKey: "UserTests")
        let loadedMemento = UserDefaults.standard.object(forKey: "UserTests") as? Memento

        // then
        XCTAssertNotNil(loadedMemento)
        XCTAssertTrue((loadedMemento! as NSDictionary).isEqual(to: expectedMemento))
    }
}
