//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class TopicsFeedResponseProcessor: ResponseProcessor<FeedResponseTopicView, FeedFetchResult> {
    
    override func process(_ response: FeedResponseTopicView?,
                          isFromCache: Bool,
                          completion: @escaping (Result<FeedFetchResult>) -> Void) {
        let result = FeedFetchResult(response: response)
        DispatchQueue.main.async {
            completion(.success(result))
        }
    }
}
