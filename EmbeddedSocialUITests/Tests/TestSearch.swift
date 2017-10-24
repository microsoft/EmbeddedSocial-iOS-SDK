//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestSearchTopicsOnline: TestOnlineHome {

    private var search: Search!

    override func setUp() {
        super.setUp()
        feedName = "SearchTopics"
        search = Search(app)
    }

    override func openScreen() {
        navigate(to: .search)

        search.topicsButton.tap()
        search.topicsQuery.tap()
        search.topicsQuery.typeText(feedName)

        app.keyboards.buttons["Search"].tap()

        sleep(1)
    }

}

class TestSearchTopicsOffline: TestOfflineHome {
    
    private var search: Search!
    
    override func setUp() {
        super.setUp()
        
        feedName = "SearchTopics"
        search = Search(app)
    }
    
    override func openScreen() {
        navigate(to: .search)
        
        search.topicsButton.tap()
        search.topicsQuery.tap()
        search.topicsQuery.typeText(feedName)
        
        app.keyboards.buttons["Search"].tap()
        
        sleep(1)
    }
    
}

class TestSearchPeopleOnline: TestFollowersOnline {
    
    private var search: Search!
    
    override func setUp() {
        super.setUp()
        
        feedName = "SearchPeople "
        feedHandle = "SearchPeople"
        
        search = Search(app)
    }
    
    override func openScreen() {
        navigate(to: .search)
        
        search.peopleButton.tap()
        search.peopleQuery.tap()
        search.peopleQuery.typeText(feedName)
        
        app.keyboards.buttons["Search"].tap()
        
        sleep(1)
    }
    
}

class TestSearchPeopleOffline: TestFollowersOffline {
    
    private var search: Search!
    
    override func setUp() {
        super.setUp()
        
        feedName = "SearchPeople "
        feedHandle = "SearchPeople"
        
        search = Search(app)
    }
    
    override func openScreen() {
        navigate(to: .search)
        
        search.peopleButton.tap()
        search.peopleQuery.tap()
        search.peopleQuery.typeText(feedName)
        
        app.keyboards.buttons["Search"].tap()
        
        sleep(1)
    }
    
}
