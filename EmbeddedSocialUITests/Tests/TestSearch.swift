//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class TestSearchTopics: TestOnlineHome, OnlineTest {
    var search: Search!
    
    override func setUp() {
        super.setUp()
        feedName = "SearchTopics"
        search = Search(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .search)
        search.topicsButton.tap()
        search.topicsQuery.tap()
        search.topicsQuery.typeText(feedName)
        sleep(1)
    }
}

class TestSearchPeople: TestFollowers {
    var search: Search!
    var sideMenu: SideMenu!
    
    override func setUp() {
        super.setUp()
        feedName = "SearchPeople "
        search = Search(app)
        sideMenu = SideMenu(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .search)
        search.peopleButton.tap()
        search.peopleQuery.tap()
        search.peopleQuery.typeText(feedName)
        sleep(1)
    }
}
