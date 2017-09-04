//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

import XCTest
@testable import EmbeddedSocial

class FeedReponseCachingTests: XCTestCase {
    
    var topicViewResponseA: FeedResponseTopicView!
    var topicViewResponseB: FeedResponseTopicView!
    
    var coreDataStack: CoreDataStack!
    var cache: CacheType!
    var services: SocialPlusServicesType!
    
    override func setUp() {
        super.setUp()
        
        // Load server response from json file
        let bundle = Bundle(for: type(of: self))
    
        let path = "topics&limit20"
        
        topicViewResponseA = FeedResponseTopicView.loadFrom(bundle: bundle, withName: path)
        topicViewResponseB = FeedResponseTopicView.loadFrom(bundle: bundle, withName: path)
        
        // Set services for cache
        services = SocialPlusServices()
        coreDataStack = services.getCoreDataStack()
        cache = services.getCache(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        
        coreDataStack = nil
        cache = nil
        services = nil
    }
    
    private func loadFeedResponseFrom(_ source: Any) -> FeedResponseTopicView? {
        let result = Decoders.decode(clazz: FeedResponseTopicView.self, source: source as AnyObject, instance: nil)
        switch result {
        case let .success(value):
            return value
        case let .failure(error):
            XCTFail("Failed to decode with error \(error)")
            return nil
        }
    }
    
    struct CacheableResponse<T: JSONEncodable>: Cacheable {
        
        let response: T
        
        init(response: T) {
            self.response = response
        }
        
        func encodeToJSON() -> Any {
            return response.encodeToJSON()
        }
    }
    
    func testThatItCachesIncomingItemAndLoadsItByHandle() {
        
        // given
        topicViewResponseA.cursor = "original cursor"
        topicViewResponseB.cursor = "new cursor"
        
        XCTAssert(topicViewResponseB.cursor != topicViewResponseA.cursor)
        
        let cacheKey = UUID().uuidString
//        let item = CacheableResponse(response: topicViewResponse )
//        cache.cacheIncoming(item, for: requestURLString)
        cache.cacheIncoming(topicViewResponseA, for: cacheKey)
        cache.cacheIncoming(topicViewResponseB, for: cacheKey)
        
//        let request = CacheFetchRequest(resultType: FeedResponseTopicView.self)
//        let predicate = PredicateBuilder().predicate(typeID: requestURLString)
        
        // when
//        let fetchedItem = cache.firstIncoming(ofType: FeedResponseTopicView.self,
//                                              predicate: predicate,
//                                              sortDescriptors: nil)
        
        let cachedItem = cache.firstIncoming(ofType: FeedResponseTopicView.self, typeID: cacheKey)
        
        XCTAssertEqual(cachedItem!.cursor, "new cursor")
    }
    
    func testFeedGetsCached() {
        
        // given 
        
        //let originalFeed = FeedResponseTopicView()
        
        
        
        
    }

}
