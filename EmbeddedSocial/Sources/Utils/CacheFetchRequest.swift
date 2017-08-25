//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct CacheFetchRequest<FetchResult: Cacheable> {
    let type: FetchResult.Type
    let page: QueryPage?
    let predicate: NSPredicate?
    let sortDescriptors: [NSSortDescriptor]?
}
