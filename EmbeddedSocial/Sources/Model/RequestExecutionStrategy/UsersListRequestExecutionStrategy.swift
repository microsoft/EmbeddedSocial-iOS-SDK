//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UsersListRequestExecutionStrategy:
CommonCacheRequestExecutionStrategy<FeedResponseUserCompactView, UsersListResponse> {
    
    var actionsProcessor: UsersListOutgoingActionsProcessor?
    
    override func postProcessResult(_ usersList: ResultType, completion: @escaping (Result<ResultType>) -> Void) {
        actionsProcessor?.applyOutgoingActions(to: usersList) { usersList in
            DispatchQueue.main.async {
                completion(.success(usersList))
            }
        }
    }
}
