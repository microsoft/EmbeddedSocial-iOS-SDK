//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestSettings: UITestBase {
    
    var sideMenu: SideMenu!
    var privacySettingOptionSwitch: XCUIElement!
    
    override func setUp() {
        super.setUp()
        
        sideMenu = SideMenu(app)
    }
    
    func openSettingsScreen() {
        sideMenu.navigate(to: .settings)
    }
    
    func testPrivacySettingsOption() {
        openSettingsScreen()

        privacySettingOptionSwitch = app.switches.element(boundBy: 0)
        
        // Setup ON state - Private visibility
        
        let onPrivacyState = "Private"
        var updatedPrivacyState = updatePrivacyState(onPrivacyState)
        
        XCTAssertTrue(updatedPrivacyState == onPrivacyState)
        XCTAssertTrue((privacySettingOptionSwitch.value as! String) == "1") // on
        
        // Setup OFF state - Public visibility
        
        let offPrivacyState = "Public"
        updatedPrivacyState = updatePrivacyState(offPrivacyState)
        
        XCTAssertTrue(updatedPrivacyState == offPrivacyState)
        XCTAssertTrue((privacySettingOptionSwitch.value as! String) == "0") // off
    }
    
}

extension TestSettings {
    
    fileprivate func updatePrivacyState(_ state: String) -> String? {
        APIConfig.values = ["visibility" : state]
        privacySettingOptionSwitch.tap()
        
        let response = APIState.getLatestResponse(forService: "visibility")
        XCTAssertNotNil(response)
        
        return response!["visibility"] as? String
    }
    
}
