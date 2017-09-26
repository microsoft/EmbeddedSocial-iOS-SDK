//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockOutgoingCommandsUploadStrategyDelegate: OutgoingCommandsUploadStrategyDelegate {
    
    //MARK: - outgoingCommandsSubmissionDidFail
    
    var outgoingCommandsSubmissionDidFailWithCalled = false
    var outgoingCommandsSubmissionDidFailWithReceivedError: Error?
    
    func outgoingCommandsSubmissionDidFail(with error: Error) {
        outgoingCommandsSubmissionDidFailWithCalled = true
        outgoingCommandsSubmissionDidFailWithReceivedError = error
    }
    
}
