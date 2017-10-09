//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class OutgoingCommandOperation: AsyncOperation {
    private(set) var error: Error?
    
    override func completeOperation() {
        self.completeOperation(with: nil)
    }
    
    func completeOperation(with error: Error?) {
        self.error = error
        if !isCancelled {
            super.completeOperation()
        }
    }
}
