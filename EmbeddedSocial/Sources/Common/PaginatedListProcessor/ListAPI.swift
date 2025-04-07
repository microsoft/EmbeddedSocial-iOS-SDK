//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ListAPI<Item> {
    
    func getPage(cursor: String?, limit: Int, completion: @escaping (Result<PaginatedResponse<Item>>) -> Void) {
        completion(.failure(APIError.notImplemented))
    }
    
    final func getPage(cursor: String?, limit: Int, skipCache: Bool, completion: @escaping (Result<PaginatedResponse<Item>>) -> Void) {
        getPage(cursor: cursor, limit: limit) { response in
            if skipCache && response.value?.isFromCache == true {
                return
            }
            completion(response)
        }
    }
}
