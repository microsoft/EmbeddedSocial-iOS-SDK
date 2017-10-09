//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class MockOperationQueue: OperationQueue {
    
    var cancelAllOperationsCalled = false
    
    override func cancelAllOperations() {
        super.cancelAllOperations()
        cancelAllOperationsCalled = true
    }
}
