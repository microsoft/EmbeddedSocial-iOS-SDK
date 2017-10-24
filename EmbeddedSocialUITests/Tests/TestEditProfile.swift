//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestEditProfile: BaseSideMenuTest {
    
    private var profile: UserProfile!
    private var editProfile: EditProfile!
    
    override func setUp() {
        super.setUp()
        
        profile = UserProfile(app)
        editProfile = EditProfile(app)
    }
    
    override func openScreen() {
        navigate(to: .userProfile)
        profile.editProfileButton.tap()
    }
    
    func testUpdateProfileDetails() {
        openScreen()
        
        editProfile.updateProfileWith(firstName: "Alan", lastName: "Poe", bio: "Lorem ipsum dolor")
        sleep(1)
        
        let request = APIState.getLatestData(forService: "me")
        
        XCTAssertEqual(request?["firstName"] as! String, "Alan", "First name doesn't match")
        XCTAssertEqual(request?["lastName"] as! String, "Poe", "Last name doesn't match")
        XCTAssertEqual(request?["bio"] as! String, "Lorem ipsum dolor", "First name doesn't match")
        
        XCTAssert(profile.textExists("Alan Poe"), "First and last name is not updated in the UI")
        XCTAssert(profile.textExists("Lorem ipsum dolor"), "Bio is not updated in the UI")
    }
}
