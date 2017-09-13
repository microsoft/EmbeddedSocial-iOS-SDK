//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

//Uncomment and run to test and debug API Mock
//
class Loop: UITestBase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAPIMock() {
        while true {}
        
//        let collectionViewsQuery = XCUIApplication().collectionViews
//        let cell = collectionViewsQuery.children(matching: .cell).element(boundBy: 3)
//        cell.buttons["icon liked"].tap()
//        
//        let cell2 = collectionViewsQuery.children(matching: .cell).element(boundBy: 2)
//        cell2.staticTexts["Reply text"].swipeDown()
//        
//        let iconLikedButton = collectionViewsQuery.children(matching: .cell).element(boundBy: 4).buttons["icon liked"]
//        iconLikedButton.tap()
//        cell2.otherElements.containing(.staticText, identifier:"Reply text").children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 0).swipeDown()
//        cell2.buttons["icon liked"].tap()
//        cell.staticTexts["Reply text"].swipeUp()
//        cell.otherElements.containing(.staticText, identifier:"Reply text").children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 0).swipeRight()
//        collectionViewsQuery.children(matching: .cell).element(boundBy: 7).buttons["icon liked"].tap()
//        iconLikedButton.tap()
//        
    }
    
}

