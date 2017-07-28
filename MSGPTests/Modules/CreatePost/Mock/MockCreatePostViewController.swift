//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import MSGP

class MockCreatePostViewController: CreatePostViewController {
    private(set) var errorShowedCount = 0
    private(set) var userShowedCount = 0
    
    override func show(error: Error) {
        errorShowedCount += 1
    }
    
    override func show(user: User) {
        userShowedCount += 1
    }
}
