//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class TrendingTopicsInteractorTests: XCTestCase {
    
    var sut: TrendingTopicsInteractor!
    var hashtagsService: MockHashtagsService!
    var networkTracker: MockNetworkTracker!
    
    override func setUp() {
        super.setUp()
        hashtagsService = MockHashtagsService()
        networkTracker = MockNetworkTracker()
        sut = TrendingTopicsInteractor(hashtagsService: hashtagsService, networkTracker: networkTracker)
    }
    
    override func tearDown() {
        super.tearDown()
        hashtagsService = nil
        networkTracker = nil
        sut = nil
    }
    
    func testThatItLoadsTrendingHashtags() {
        let items: [Hashtag] = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let response = PaginatedResponse<Hashtag>(items: items, cursor: UUID().uuidString, isFromCache: true)
        hashtagsService.getTrendingReturnValue = .success(response)
        
        var result: Result<[Hashtag]>?
        sut.getTrendingHashtags { result = $0 }
        
        expect(result).toEventuallyNot(beNil())
        expect(result?.value).toEventually(equal(items))
        expect(self.hashtagsService.getTrendingCalled).toEventually(beTrue())
    }
    
    func testThatItHandlesLoadTrendingHashtagsError() {
        hashtagsService.getTrendingReturnValue = .failure(APIError.unknown)
        
        var result: Result<[Hashtag]>?
        sut.getTrendingHashtags { result = $0 }
        
        expect(result).toEventuallyNot(beNil())
        expect(result?.error).toEventually(matchError(APIError.unknown))
        expect(self.hashtagsService.getTrendingCalled).toEventually(beTrue())
    }
    
    func testReload_thatAPIResultIsUsed() {
        let items: [Hashtag] = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let response = PaginatedResponse<Hashtag>(items: items, cursor: UUID().uuidString, isFromCache: false)
        hashtagsService.getTrendingReturnValue = .success(response)
        networkTracker.isReachable = true
        
        var result: Result<[Hashtag]>?
        sut.reloadTrendingHashtags { result = $0 }
        
        expect(result).toEventuallyNot(beNil())
        expect(result?.value).toEventually(equal(items))
        expect(self.hashtagsService.getTrendingCalled).toEventually(beTrue())
    }
    
    func testReload_thatCachedResultIsIgnored_whenConnectionIsAvailable() {
        let timeout: TimeInterval = 0.1
        let items: [Hashtag] = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let response = PaginatedResponse<Hashtag>(items: items, cursor: UUID().uuidString, isFromCache: true)
        hashtagsService.getTrendingReturnValue = .success(response)
        networkTracker.isReachable = true

        var result: Result<[Hashtag]>?
        sut.reloadTrendingHashtags { result = $0 }
        
        expect(result).toEventually(beNil(), timeout: timeout)
        expect(self.hashtagsService.getTrendingCalled).toEventually(beTrue(), timeout: timeout)
    }
    
    func testReload_thatCachedResultIsUsed_whenConnectionIsNotAvailable() {
        let items: [Hashtag] = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let response = PaginatedResponse<Hashtag>(items: items, cursor: UUID().uuidString, isFromCache: true)
        hashtagsService.getTrendingReturnValue = .success(response)
        networkTracker.isReachable = false

        var result: Result<[Hashtag]>?
        sut.reloadTrendingHashtags { result = $0 }
        
        expect(result).toEventuallyNot(beNil())
        expect(result?.value).toEventually(equal(items))
        expect(self.hashtagsService.getTrendingCalled).toEventually(beTrue())
    }
}
