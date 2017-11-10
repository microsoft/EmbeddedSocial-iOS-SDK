//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ActivityFeedProcessor: ResponseProcessor<FeedResponseActivityView, PaginatedResponse<ActivityView> > {
    
    override func process(_ response: FeedResponseActivityView?,
                          isFromCache: Bool,
                          completion: @escaping (Result<PaginatedResponse<ActivityView> >) -> Void) {
        
        var result: PaginatedResponse<ActivityView> = PaginatedResponse(items: response?.data ?? [],
                                                                        cursor: response?.cursor,
                                                                        isFromCache: isFromCache)
        
        DispatchQueue.main.async {
            completion(.success(result))
        }
    }
}
