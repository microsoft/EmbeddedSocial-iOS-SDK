//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

import XCTest
@testable import EmbeddedSocial

class FeedCacheTests: XCTestCase {
    
    var topicViewResponse: FeedResponseTopicView!
    
    var coreDataStack: CoreDataStack!
    var cache: CacheType!
    var services: SocialPlusServicesType!
    
    override func setUp() {
        super.setUp()
        
        // Load server response from json file
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "topics&limit20", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let json = try? JSONSerialization.jsonObject(with: data!)
        
        let result = Decoders.decode(clazz: FeedResponseTopicView.self, source: json as AnyObject, instance: nil)
        switch result {
        case let .success(value):
            topicViewResponse = value
        case let .failure(error):
            XCTFail("Failed to decode with error \(error)")
        }
        
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
        let cacheKey = "aaa"//"/v0.7/users/me/topics/popular"
//        let item = CacheableResponse(response: topicViewResponse )
//        cache.cacheIncoming(item, for: requestURLString)
        cache.cacheIncoming(topicViewResponse, for: cacheKey)
        
//        let request = CacheFetchRequest(resultType: FeedResponseTopicView.self)
//        let predicate = PredicateBuilder().predicate(typeID: requestURLString)
        
        // when
//        let fetchedItem = cache.firstIncoming(ofType: FeedResponseTopicView.self,
//                                              predicate: predicate,
//                                              sortDescriptors: nil)
        
        let cachedItem = cache.firstIncoming(ofType: FeedResponseTopicView.self, typeID: cacheKey)

        let a = 1
        // then
//        XCTAssertEqual(cachedItem, cachedItem)
    }
    
    func testFeedGetsCached() {
        
        // given 
        
        //let originalFeed = FeedResponseTopicView()
        
        
        
        
    }

}
