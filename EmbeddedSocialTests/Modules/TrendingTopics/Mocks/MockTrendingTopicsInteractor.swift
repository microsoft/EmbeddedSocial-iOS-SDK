//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockTrendingTopicsInteractor: TrendingTopicsInteractorInput {
    
    //MARK: - getTrendingHashtags
    
    var getTrendingHashtagsCompletionCalled = false
    var getTrendingHashtagsCompletionReturnValue: Result<[Hashtag]>!
    
    func getTrendingHashtags(completion: @escaping (Result<[Hashtag]>) -> Void) {
        getTrendingHashtagsCompletionCalled = true
        completion(getTrendingHashtagsCompletionReturnValue)
    }
    
    //MARK: - reloadTrendingHashtags
    
    var reloadTrendingHashtagsCompletionCalled = false
    var reloadTrendingHashtagsCompletionReturnValue: Result<[Hashtag]>!
    
    func reloadTrendingHashtags(completion: @escaping (Result<[Hashtag]>) -> Void) {
        reloadTrendingHashtagsCompletionCalled = true
        completion(reloadTrendingHashtagsCompletionReturnValue)
    }
    
}
