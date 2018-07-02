//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct CacheFetchRequest<FetchResult: Cacheable> {
    let resultType: FetchResult.Type
    let page: QueryPage?
    let predicate: NSPredicate?
    let sortDescriptors: [NSSortDescriptor]?
    
    init(resultType: FetchResult.Type, page: QueryPage? = nil,
         predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        self.resultType = resultType
        self.page = page
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
    }
}
