//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

// MARK: - Today section tests

class TestPopularTodayOnline: TestOnlineHome {
    
    private var popularTopics: PopularTopics!
    
    override func setUp() {
        super.setUp()
        
        feedName = "popular/Today"
        popularTopics = PopularTopics(app)
    }
    
    override func openScreen() {
        navigate(to: .popular)
        popularTopics.select(section: .today)
    }
    
}

class TestPopularTodayOffline: TestOfflineHome {
    
    private var popularTopics: PopularTopics!
    
    override func setUp() {
        super.setUp()
        
        feedName = "popular/Today"
        popularTopics = PopularTopics(app)
    }
    
    override func openScreen() {
        navigate(to: .popular)
        popularTopics.select(section: .today)
    }
    
}

// MARK: - This Week section tests

class TestPopularThisWeekOnline: TestOnlineHome {
    
    private var popularTopics: PopularTopics!
    
    override func setUp() {
        super.setUp()
        
        feedName = "popular/ThisWeek"
        popularTopics = PopularTopics(app)
    }
    
    override func openScreen() {
        navigate(to: .popular)
        popularTopics.select(section: .thisWeek)
    }
    
}

class TestPopularThisWeekOffline: TestOfflineHome {
    
    private var popularTopics: PopularTopics!
    
    override func setUp() {
        super.setUp()
        
        feedName = "popular/ThisWeek"
        popularTopics = PopularTopics(app)
    }
    
    override func openScreen() {
        navigate(to: .popular)
        popularTopics.select(section: .thisWeek)
    }
    
}

// MARK: - All Time section tests

class TestPopularAllTimeOnline: TestOnlineHome {
    
    private var popularTopics: PopularTopics!
    
    override func setUp() {
        super.setUp()
        
        feedName = "popular/AllTime"
        popularTopics = PopularTopics(app)
    }
    
    override func openScreen() {
        navigate(to: .popular)
        popularTopics.select(section: .all)
    }
    
}

class TestPopularAllTimeOffline: TestOfflineHome {
    
    private var popularTopics: PopularTopics!
    
    override func setUp() {
        super.setUp()
        
        feedName = "popular/AllTime"
        popularTopics = PopularTopics(app)
    }
    
    override func openScreen() {
        navigate(to: .popular)
        popularTopics.select(section: .all)
    }
    
}
