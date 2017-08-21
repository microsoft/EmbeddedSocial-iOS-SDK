//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class TestEditProfile: UITestBase {
    var sideMenu: SideMenu!
    var profile: UserProfile!
    var editProfile: EditProfile!
    
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
        profile = UserProfile(app)
        editProfile = EditProfile(app)
    }
    
    func openScreen() {
        sideMenu.navigateToUserProfile()
        profile.editProfileButton.tap()
        
    }
    
    func testUpdateProfileDetails() {
        openScreen()
        
        editProfile.firstNameInput.clearText()
        editProfile.firstNameInput.typeText("Alan")
        editProfile.lastNameInput.clearText()
        editProfile.lastNameInput.typeText("Poe")
        editProfile.bioInput.clearText()
        editProfile.bioInput.typeText("Lorem ipsum dolor")
        
        editProfile.saveButton.tap()
        
        let request = APIState.getLatestData(forService: "me")
        
        XCTAssertEqual(request?["firstName"] as! String, "Alan", "First name doesn't match")
        XCTAssertEqual(request?["lastName"] as! String, "Poe", "Last name doesn't match")
        XCTAssertEqual(request?["bio"] as! String, "Lorem ipsum dolor", "First name doesn't match")
        
        XCTAssert(profile.textExists("Alan Poe"), "First and last name is not updated in the UI")
        XCTAssert(profile.textExists("Lorem ipsum dolor"), "Bio is not updated in the UI")
    }
}
