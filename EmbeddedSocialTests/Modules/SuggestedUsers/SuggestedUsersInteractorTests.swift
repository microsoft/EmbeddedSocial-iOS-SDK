//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class SuggestedUsersInteractorTests: XCTestCase {
    
    var api: MockFacebookAPI!
    var sut: SuggestedUsersInteractor!
    
    override func setUp() {
        super.setUp()
        api = MockFacebookAPI()
        sut = SuggestedUsersInteractor(facebookAPI: api)
    }
    
    override func tearDown() {
        super.tearDown()
        api = nil
        sut = nil
    }
    
    func testPermissionGranted() {
        api.hasGrantedFriendsListPermission = true
        expect(self.sut.isFriendsListPermissionGranted).to(beTrue())
        
        api.hasGrantedFriendsListPermission = false
        expect(self.sut.isFriendsListPermissionGranted).to(beFalse())
    }
    
    func testRequestPermission() {
        let creds = CredentialsList(provider: .facebook, accessToken: "1", socialUID: "2")
        let user = SocialUser(credentials: creds, firstName: nil, lastName: nil, email: nil, photo: nil)
        api.loginResult = .success(user)
        
        var result: Result<CredentialsList>?
        let vc = UIViewController()
        sut.requestFriendsListPermission(parentViewController: vc) { result = $0 }
        
        expect(result?.value).toEventually(equal(creds))
        expect(self.api.loginCalled).to(beTrue())
        expect(self.api.loginInputViewController).to(equal(vc))
    }
}

