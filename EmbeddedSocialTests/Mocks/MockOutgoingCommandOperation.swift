//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockOutgoingCommandOperation: OutgoingCommandOperation {
    private(set) var completeOperationWithCalled = false
    private(set) var completeOperationWithInputError: Error?
    
    override var error: Error? {
        return _error
    }
    
    private var _error: Error?
    
    func setError(_ error: Error?) {
        _error = error
    }
    
    override func completeOperation(with error: Error?) {
        completeOperationWithCalled = true
        completeOperationWithInputError = error
        super.completeOperation(with: error)
    }
    
    override func main() {
        completeOperation(with: _error)
    }
}
