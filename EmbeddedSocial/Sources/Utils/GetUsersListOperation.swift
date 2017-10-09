//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class GetUsersListOperation: AsynсOperation {
    private let api: UsersListAPI
    private let cursor: String?
    private let pageSize: Int
    private let completion: (Result<UsersListResponse>, String) -> Void
    private let pageID: String
    
    init(api: UsersListAPI,
         cursor: String?,
         pageSize: Int = Constants.UserList.pageSize,
         completion: @escaping (Result<UsersListResponse>, String) -> Void) {
        
        self.api = api
        self.cursor = cursor
        self.pageSize = pageSize
        self.completion = completion
        pageID = UUID().uuidString
        
        super.init()
    }
    
    override func main() {
        api.getUsersList(cursor: cursor, limit: pageSize) { [weak self] result in
            guard let strongSelf = self, !strongSelf.isCancelled else {
                return
            }
            strongSelf.completion(result, strongSelf.pageID)
            
            // ignore response from cache
            if let value = result.value, value.isFromCache {
                return
            }
            
            strongSelf.completeOperation()
        }
    }
}
