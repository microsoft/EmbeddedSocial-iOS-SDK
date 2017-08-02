//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct PaginatedResponse<Item, Cursor> {
    let items: [Item]
    let error: Error?
    let cursor: Cursor?
}

extension PaginatedResponse where Item == User, Cursor == String {
    func reduce(result: Result<([User], String?)>) -> PaginatedResponse {
        let itemsToAdd = result.value?.0 ?? []
        return PaginatedResponse(items: itemsToAdd + items,
                                 error: result.error ?? error,
                                 cursor: result.value?.1)
    }
}
