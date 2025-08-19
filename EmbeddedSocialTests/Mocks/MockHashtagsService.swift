//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockHashtagsService: HashtagsServiceType {
    
    // MARK: - getTrending
    var getTrendingCalled = false
    var getTrendingReturnValue: Result<PaginatedResponse<Hashtag>>!

    func getTrending(completion: @escaping (Result<PaginatedResponse<Hashtag>>) -> Void) {
        getTrendingCalled = true
        completion(getTrendingReturnValue)
    }
}
