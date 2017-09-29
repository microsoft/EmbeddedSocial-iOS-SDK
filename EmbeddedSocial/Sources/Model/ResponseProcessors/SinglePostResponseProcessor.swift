//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SinglePostResponseProcessor: ResponseProcessor<TopicView, Post> {
    
    override func process(_ response: TopicView?, isFromCache: Bool, completion: @escaping (Result<Post>) -> Void) {
        
        DispatchQueue.main.async {
            if let response = response {
                completion(.success(Post(data: response)))
            } else {
                completion(.failure(APIError.failedRequest))
            }
        }
    }
}
