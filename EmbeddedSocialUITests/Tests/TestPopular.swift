//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest


class TestPopularToday: TestOnlineHome {
    var popular: PopularTopics!
    
    override func setUp() {
        super.setUp()
        feedName = "popular/Today"
        popular = PopularTopics(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .popular)
        popular.todayButton.tap()
        sleep(1)
    }
    
}

class TestPopularThisWeek: TestOnlineHome {
    var popular: PopularTopics!
    
    override func setUp() {
        super.setUp()
        feedName = "popular/ThisWeek"
        popular = PopularTopics(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .popular)
        popular.thisWeekButton.tap()
        sleep(1)
    }
    
}

class TestPopularAllTime: TestOnlineHome {
    var popular: PopularTopics!
    
    override func setUp() {
        super.setUp()
        feedName = "popular/AllTime"
        popular = PopularTopics(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .popular)
        popular.allTimeButton.tap()
        sleep(1)
    }
    
}
