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
    
    var likesService: LikesService!
    
    override func setUp() {
        super.setUp()
        
        // Load server response from json file
        let bundle = Bundle(for: type(of: self))
    
        let path = "topics&limit20"
        
        topicViewResponseA = FeedResponseTopicView.loadFrom(bundle: bundle, withName: path)
        topicViewResponseB = FeedResponseTopicView.loadFrom(bundle: bundle, withName: path)
        
        // Set services for cache
        services = SocialPlusServices()
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        cache = services.getCache(coreDataStack: coreDataStack)
        
        likesService = LikesService()
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
    
    func testSocialActionExecuter() {
        
        // given
        
        let actionsCache = SocialActionsCache(cache: cache)
        let executer = CachedActionsExecuter(cache: actionsCache)
        let actions = actionsCache.getAllCachedActions()
        
        // when
        
        //executer.execute(actions.)

    }
    
    func testThatUndoActionOverridesOriginalAction() {
        
        // given
        let authorization = UUID().uuidString
        let postHandle = UUID().uuidString
        let likeRequestBuilder: RequestBuilder<Object> = LikesAPI.topicLikesPostLikeWithRequestBuilder(topicHandle: postHandle,
                                                                                            authorization: authorization)
        
        let dislikeRequestBuilder: RequestBuilder<Object> = LikesAPI.topicLikesDeleteLikeWithRequestBuilder(topicHandle: postHandle,
                                                                                                      authorization: authorization)
        
        let actionsCache = SocialActionsCache(cache: cache)
        let likePostAction = SocialActionRequestBuilder.build(method: likeRequestBuilder.method,
                                                       handle: postHandle,
                                                       action: .like)
        
        let dislikePostAction = SocialActionRequestBuilder.build(method: dislikeRequestBuilder.method,
                                                       handle: postHandle,
                                                       action: .like)
        
        // when
        actionsCache.cache(likePostAction)
        actionsCache.cache(dislikePostAction)
        
        // then
        let results = actionsCache.getAllCachedActions()
        XCTAssertTrue(results.count == 1)
        XCTAssertTrue(results.first!.actionType == .like)
        XCTAssertTrue(results.first!.actionMethod == .delete)
    }
    
    
    func testThatActionsAreCachedProperly() {
        
        // given
        let authorization = UUID().uuidString
        let postHandle = UUID().uuidString
        let likeRequestBuilder: RequestBuilder<Object> = LikesAPI.topicLikesPostLikeWithRequestBuilder(
            topicHandle: postHandle,
            authorization: authorization)
        let pinRequestBuilder: RequestBuilder<Object> = PinsAPI.myPinsDeletePinWithRequestBuilder(
            topicHandle: postHandle,
            authorization: authorization)
        
        let actionsCache = SocialActionsCache(cache: cache)
        
        // when
        let likePostAction = SocialActionRequestBuilder.build(method: likeRequestBuilder.method,
                                                       handle: postHandle,
                                                       action: .like)
        
        let deletePinAction = SocialActionRequestBuilder.build(method: pinRequestBuilder.method,
                                                       handle: postHandle,
                                                       action: .pin)
        
        actionsCache.cache(likePostAction)
        actionsCache.cache(deletePinAction)
        
        // then
        let results = actionsCache.getAllCachedActions().flatMap { $0.actionType }
        
        XCTAssertTrue(results.count == 2)
        XCTAssertTrue(results.contains(.like))
        XCTAssertTrue(results.contains(.pin))
        XCTAssertTrue(likePostAction.actionMethod == .post)
        XCTAssertTrue(deletePinAction.actionMethod == .delete)
    }

}
