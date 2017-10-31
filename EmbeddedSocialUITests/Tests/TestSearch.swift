//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestSearchTopicsOnline: TestOnlineHome {

    private var search: Search!
    private var trendingTopics: TrendingTopicsFeed!

    override func setUp() {
        super.setUp()
        
        feedName = "SearchTopics"
        
        search = Search(app)
        trendingTopics = TrendingTopicsFeed(app)
    }

    override func openScreen() {
        navigate(to: .search)
        search.search(feedName, for: .topics)
        sleep(1)
    }
    
    func testSearchQuerySavedToHistory() {
        openScreen()
        
        // we should already have at least one item in search
        
        let searchHistory = search.getHistory()
        XCTAssertTrue(searchHistory.getHistoryItemsCount() != 0)
        
        let lastSearchQuery = searchHistory.getHistoryItem(at: 0).getQuery()
        XCTAssertEqual(feedName, lastSearchQuery)
    }
    
    func testSearchFromSearchHistory() {
        openScreen()
        
        let searchHistoryItem = search.getHistory().getHistoryItem(at: 0)
        let searchQuery = searchHistoryItem.getQuery()
        searchHistoryItem.asUIElement().tap()
        
        let (index, post) = feed.getRandomPost()
        XCTAssertEqual(post.getTitle().label, "\(searchQuery)\(index)")
    }
    
    func testTrendingTopicsSource() {
        navigate(to: .search)
        
        let (index, topic) = trendingTopics.getRandomTopic()
        XCTAssertEqual("#hashtag\(index)", topic.getName())
    }
    
    func testSearchByTrendingTopic() {
        navigate(to: .search)
        
        let (_, topic) = trendingTopics.getRandomTopic()
        let topicName = topic.getName()
        topic.asUIElement().tap()
        
        let (index, post) = feed.getRandomPost()
        XCTAssertEqual(post.getTitle().label, "\(topicName)\(index)")
    }
    
}

class TestSearchTopicsOffline: TestOfflineHome {
    
    private var search: Search!
    private var trendingTopics: TrendingTopicsFeed!
    
    override func setUp() {
        super.setUp()
        
        feedName = "SearchTopics"
        
        search = Search(app)
        trendingTopics = TrendingTopicsFeed(app)
    }
    
    override func openScreen() {
        navigate(to: .search)
        search.search(feedName, for: .topics)
        sleep(1)
    }
    
    func testSearchQuerySavedToHistory() {
        navigate(to: .search)
        
        makePullToRefreshWithoutReachability(with: trendingTopics.asUIElement())
        
        search.search("OfflineSearch", for: .topics)
        
        let history = search.getHistory()
        XCTAssertEqual("OfflineSearch", history.getHistoryItem(at: 0).getQuery())
    }
    
    func testSearchFromSearchHistory() {
        openScreen()
        
        var needReachabilityDisabling = true
        for _ in 1...2 {
            // load topics online on first iteration
            
            let searchHistoryItem = search.getHistory().getHistoryItem(at: 0)
            let searchQuery = searchHistoryItem.getQuery()
            searchHistoryItem.asUIElement().tap()
            
            if needReachabilityDisabling {
                makePullToRefreshWithoutReachability(with: feed.asUIElement())
                needReachabilityDisabling = false
                continue
            }
            
            let (index, post) = feed.getRandomPost()
            XCTAssertEqual(post.getTitle().label, "\(searchQuery)\(index)")
        }
    }
    
    func testTrendingTopicsSource() {
        navigate(to: .search)
        
        makePullToRefreshWithoutReachability(with: trendingTopics.asUIElement())
        
        let (index, topic) = trendingTopics.getRandomTopic()
        XCTAssertEqual("#hashtag\(index)", topic.getName())
    }
    
    func testSearchByTrendingTopic() {
        navigate(to: .search)
        
        var needReachabilityDisabling = true
        for _ in 1...2 {
            let topic = trendingTopics.getTopic(at: 0)
            let topicName = topic.getName()
            topic.asUIElement().tap()
            
            if needReachabilityDisabling {
                makePullToRefreshWithoutReachability(with: trendingTopics.asUIElement())
                needReachabilityDisabling = false
                
                search.clear()
                navigate(to: .home)
                navigate(to: .search)
                
                continue
            }
            
            let (index, post) = feed.getRandomPost()
            XCTAssertEqual(post.getTitle().label, "\(topicName)\(index)")
        }
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
        search.search(feedName, for: .people)
        sleep(1)
    }
    
    func testSuggestedUsersSource() {
        navigate(to: .search)
        search.select(item: .people)
        
        let (index, follower) = followersFeed.getRandomFollower()
        XCTAssertTrue(follower.textExists("Suggested User\(index)"))
    }
    
    func testSuggestedUserFollowing() {
        navigate(to: .search)
        search.select(item: .people)
        
        feedHandle = "SuggestedUser"
        
        let (index, follower) = followersFeed.getRandomFollower()
        
        follower.follow()
        checkIsFollowed(follower, at: index)
        
        follower.follow()
        checkIsUnfollowed(follower, at: index)
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
        search.search(feedName, for: .people)
        sleep(1)
    }
    
    func testSuggestedUsersSource() {
        navigate(to: .search)
        search.select(item: .people)
        
        makePullToRefreshWithoutReachability(with: followersFeed.asUIElement())

        let (index, follower) = followersFeed.getRandomFollower()
        XCTAssertTrue(follower.textExists("Suggested User\(index)"))
    }
    
    func testSuggestedUserFollowing() {
        navigate(to: .search)
        search.select(item: .people)
        
        feedHandle = "SuggestedUser"
        makePullToRefreshWithoutReachability(with: followersFeed.asUIElement())
        sleep(1)
        
        let (index, follower) = followersFeed.getRandomFollower()
        
        follower.follow()
        checkIsFollowed(follower, at: index)
        
        follower.follow()
        checkIsUnfollowed(follower, at: index)
    }
    
}
