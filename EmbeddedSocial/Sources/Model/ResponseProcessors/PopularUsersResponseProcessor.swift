//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class PopularUsersResponseProcessor: ResponseProcessor<FeedResponseUserProfileView, UsersListResponse> {
    
    override func process(_ response: FeedResponseUserProfileView?,
                          isFromCache: Bool,
                          completion: @escaping (Result<UsersListResponse>) -> Void) {
        
        let usersList = UsersListResponse(response: response, isFromCache: isFromCache)
        DispatchQueue.main.async {
            completion(.success(usersList))
        }
    }
}
