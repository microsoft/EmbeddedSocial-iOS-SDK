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
    var services: SocialPlusServicesType!
    
    var likesService: MockLikesService!
    
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
        
        likesService = MockLikesService()
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
    
    func testThatIsExecutesOutgoingTransactionsWhenConnectionAppears() {
      
        // given
        let likesService = MockLikesService()
        let cacheAdapter = SocialActionsCacheAdapterProtocolMock()
        let outgoingActionsProcessor = CachedActionsExecuter(cacheAdapter: cacheAdapter, likesService: likesService)
        
        // 4 unique actions
        let actionsParameters = [
            ("POST", uniqueString(), SocialActionRequest.ActionType.like),
            ("DELETE", uniqueString(), SocialActionRequest.ActionType.like),
            ("POST", uniqueString(), SocialActionRequest.ActionType.pin),
            ("DELETE", uniqueString(), SocialActionRequest.ActionType.pin)]
        
        let cachedActions = actionsParameters.map {
            SocialActionRequestBuilder.build(method: $0.0, handle: $0.1, action: $0.2)
        }
    
        cacheAdapter.getAllCachedActionsReturnValue = Set(cachedActions)
        XCTAssertTrue(cacheAdapter.getAllCachedActions().count == actionsParameters.count)

        // when
        outgoingActionsProcessor.networkStatusDidChange(true)
        
        // then
        XCTAssertTrue(likesService.deletePinPostHandleCompletionCalled)
        XCTAssertTrue(likesService.deleteLikePostHandleCompletionCalled)
        XCTAssertTrue(likesService.postPinPostHandleCompletionCalled)
        XCTAssertTrue(likesService.postLikePostHandleCompletionCalled)
    }
    
    func testThatItExecutesOutgoingTransactions() {
        
        // given
        let postHandleA = uniqueString()
        let postHandleB = uniqueString()
        
        let actionsCache = SocialActionsCacheAdapter(cache: cache)
        let executer = CachedActionsExecuter(cacheAdapter: actionsCache, likesService: likesService)
        
        let likePostAction = SocialActionRequestBuilder.build(
            method: "POST",
            handle: postHandleA,
            action: .like)
        
        let pinPostAction = SocialActionRequestBuilder.build(
            method: "POST",
            handle: postHandleA,
            action: .pin)
        
        let unLikePostAction = SocialActionRequestBuilder.build(
            method: "DELETE",
            handle: postHandleB,
            action: .like)
        
        let unPinPostAction = SocialActionRequestBuilder.build(
            method: "DELETE",
            handle: postHandleB,
            action: .pin)
        
        let actions = [
            likePostAction,
            pinPostAction,
            unLikePostAction,
            unPinPostAction]
        
        actions.forEach { actionsCache.cache($0) }
        XCTAssertTrue(actionsCache.getAllCachedActions().count == actions.count)
        
        // when
        executer.executeAll()
        
        // then
        XCTAssertTrue(likesService.postLikePostHandleCompletionCalled == true)
        XCTAssertTrue(likesService.postLikePostHandleCompletionReceivedArguments?.postHandle == postHandleA)
        XCTAssertTrue(likesService.postPinPostHandleCompletionCalled == true)
        XCTAssertTrue(likesService.postPinPostHandleCompletionReceivedArguments?.postHandle == postHandleA)
        XCTAssertTrue(likesService.deleteLikePostHandleCompletionCalled == true)
        XCTAssertTrue(likesService.deleteLikePostHandleCompletionReceivedArguments?.postHandle == postHandleB)
        XCTAssertTrue(likesService.deletePinPostHandleCompletionCalled == true)
        XCTAssertTrue(likesService.deletePinPostHandleCompletionReceivedArguments?.postHandle == postHandleB)
        
        XCTAssertTrue(actionsCache.getAllCachedActions().count == 0, "all executed actions must be erased")
    }
    
    func testThatActionGetsCachedAndRemoved() {
        
        // given
        let postHandle = uniqueString()
        let actionsCache = SocialActionsCacheAdapter(cache: cache)
        
        let likePostAction = SocialActionRequestBuilder.build(
            method: "POST",
            handle: postHandle,
            action: .like)
        
        let unPinPostAction = SocialActionRequestBuilder.build(
            method: "DELETE",
            handle: postHandle,
            action: .pin)
        
        // when
        actionsCache.cache(likePostAction)
        XCTAssertTrue(actionsCache.getAllCachedActions().count == 1)
        actionsCache.cache(unPinPostAction)
        XCTAssertTrue(actionsCache.getAllCachedActions().count == 2)
        actionsCache.remove(likePostAction)
        
        // then
        XCTAssertTrue(actionsCache.getAllCachedActions().count == 1)
        XCTAssertTrue(actionsCache.getAllCachedActions().first?.actionType == .pin)
        XCTAssertTrue(actionsCache.getAllCachedActions().first?.actionMethod == .delete)
    }
    
    func testThatUndoActionOverridesOriginalAction() {
        
        // given
        let postHandle = UUID().uuidString
        
        let actionsCache = SocialActionsCacheAdapter(cache: cache)
        
        let likePostAction = SocialActionRequestBuilder.build(
            method: "POST",
            handle: postHandle,
            action: .like)
        
        let unLikePostAction = SocialActionRequestBuilder.build(
            method: "DELETE",
            handle: postHandle,
            action: .like)
        
        // when
        actionsCache.cache(likePostAction)
        actionsCache.cache(unLikePostAction)
        
        // then
        let results = actionsCache.getAllCachedActions()
        XCTAssertTrue(results.count == 0)
    }
    
    func testThatActionsAreCachedProperly() {
        
        // given
        let postHandle = UUID().uuidString
        let actionsCache = SocialActionsCacheAdapter(cache: cache)
        
        let likePostAction = SocialActionRequestBuilder.build(
            method: "POST",
            handle: postHandle,
            action: .like)
        
        let deletePinAction = SocialActionRequestBuilder.build(
            method: "DELETE",
            handle: postHandle,
            action: .pin)
        // when
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
    
    
//    func testThat
    
}
