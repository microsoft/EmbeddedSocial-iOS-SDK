//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension Cache {
    
    struct Queries<T: Transaction> {
        typealias Fetch<T: Transaction> = (NSPredicate?, QueryPage?, [NSSortDescriptor]?) -> [T]
        typealias Make<T: Transaction> = () -> T
        typealias AsyncFetch<T: Transaction> = (NSPredicate?, QueryPage?, [NSSortDescriptor]?, @escaping ([T]) -> Void) -> Void
        
        let fetch: Fetch<T>
        let make: Make<T>
        let fetchAsync: AsyncFetch<T>
    }
}
