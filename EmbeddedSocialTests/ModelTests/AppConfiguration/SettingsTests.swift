//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class SettingsTests: XCTestCase {
    
    func testSetupWithDummyData() {
        let settings = Settings(config: makeNormalConfig())
        expect(settings).notTo(beNil())
    }
    
    func testSetupWithRealData() {
        let config = PlistLoader.loadPlist(name: "config")
        let settingsConfig = config?["application"] as? [String: Any] ?? [:]
        expect(Settings(config: settingsConfig)).notTo(beNil())
    }
    
    func testFieldsValidity() {
        let config = makeNormalConfig()
        
        let settings = Settings(config: config)
        
        expect(settings?.serverURL).to(equal(config["serverURL"] as? String))
        expect(settings?.appKey).to(equal(config["appKey"] as? String))
        
        expect(settings?.numberOfCommentsToShow).to(equal(config["numberOfCommentsToShow"] as? Int))
        expect(settings?.numberOfCommentsToShow).to(equal(config["numberOfCommentsToShow"] as? Int))
        
        expect(settings?.showGalleryView).to(equal(config["showGalleryView"] as? Bool))
        expect(settings?.searchEnabled).to(equal(config["searchEnabled"] as? Bool))
    }
    
    private func intValue(from any: Any?) -> Int? {
        return (any as? NSNumber)?.intValue
    }
    
    private func makeNormalConfig() -> [String: Any] {
        return [
            "serverURL": UUID().uuidString,
            "appKey": UUID().uuidString,
            "numberOfCommentsToShow": 20,
            "numberOfRepliesToShow": 20,
            "showGalleryView": true,
            "searchEnabled": true
        ]
    }
}
