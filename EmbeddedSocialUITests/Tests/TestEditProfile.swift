//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class BaseTestEditProfile: BaseSideMenuTest {
    
    var profile: UserProfile!
    
    private var editProfile: EditProfile!
    
    override func setUp() {
        super.setUp()
        
        profile = UserProfile(app)
        editProfile = EditProfile(app)
    }
    
    override func openScreen() {
        navigate(to: .userProfile)
    }
    
    func testUpdateProfileDetails() {
        profile.editProfileButton.tap()
        
        editProfile.updateProfileWith(firstName: "Alan", lastName: "Poe", bio: "Lorem ipsum dolor")
        sleep(1)
        
        XCTAssert(profile.textExists("Alan Poe"), "First and last name is not updated in the UI")
        XCTAssert(profile.textExists("Lorem ipsum dolor"), "Bio is not updated in the UI")
    }
}

class TestEditProfileOnline: BaseTestEditProfile, OnlineTest {
    
    override func testUpdateProfileDetails() {
        openScreen()
        
        super.testUpdateProfileDetails()
        
        let request = APIState.getLatestData(forService: "me")
        XCTAssertEqual(request?["firstName"] as! String, "Alan", "First name doesn't match")
        XCTAssertEqual(request?["lastName"] as! String, "Poe", "Last name doesn't match")
        XCTAssertEqual(request?["bio"] as! String, "Lorem ipsum dolor", "First name doesn't match")
    }
    
}

class TestEditProfileOffline: BaseTestEditProfile, OfflineTest {
    
    override func testUpdateProfileDetails() {
        openScreen()
        makePullToRefreshWithoutReachability(with: profile.asUIElement())
        super.testUpdateProfileDetails()
    }
    
}
