//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

import XCTest
@testable import EmbeddedSocial

class FeedCachingTests: XCTestCase {
    
    var topicViewResponseA: FeedResponseTopicView!
    var topicViewResponseB: FeedResponseTopicView!
    
    var coreDataStack: CoreDataStack!
    var cache: CacheType!
    
    var likesService: MockLikesService!
    
    override func setUp() {
        super.setUp()
        
        // Load server response from json file
        let bundle = Bundle(for: type(of: self))
        
        let path = "topics&limit20"
        
        topicViewResponseA = FeedResponseTopicView.loadFrom(bundle: bundle, withName: path)
        topicViewResponseB = FeedResponseTopicView.loadFrom(bundle: bundle, withName: path)
        
        // Set services for cache
        let services = SocialPlusServices()
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        cache = services.getCache(coreDataStack: coreDataStack)
        
        likesService = MockLikesService()
    }
    
    override func tearDown() {
        
        coreDataStack = nil
        cache = nil
        likesService = nil
        topicViewResponseA = nil
        topicViewResponseB = nil
        
        super.tearDown()
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
    
    func testFeedGetsCached() {
        
        // given
        
        //let originalFeed = FeedResponseTopicView()
    }
    
}
