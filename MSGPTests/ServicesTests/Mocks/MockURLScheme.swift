//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import MSGP

struct MockURLScheme: URLScheme {
    private let result: Bool
    
    init(result: Bool) {
        self.result = result
    }
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return result
    }
}
