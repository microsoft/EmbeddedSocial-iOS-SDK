//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ActivityFeedProcessor: ResponseProcessor<FeedResponseActivityView, ListResponse<ActivityView> > {
    
    override func process(_ response: FeedResponseActivityView?,
                          isFromCache: Bool,
                          completion: @escaping (Result<ListResponse<ActivityView> >) -> Void) {
        
        var result: ListResponse<ActivityView> = ListResponse()
        
        if let items = response?.data {
            result.items = items
        }
        
        result.isFromCache = isFromCache
        result.cursor = response?.cursor
        
        DispatchQueue.main.async {
            completion(.success(result))
        }
    }
}
