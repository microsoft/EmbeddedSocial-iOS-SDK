//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockOutgoingCommandsUploadStrategy: OutgoingCommandsUploadStrategyType {
    
    //MARK: - restartSubmission
    
    var restartSubmissionCalled = false
    
    func restartSubmission() {
        restartSubmissionCalled = true
    }
    
    //MARK: - cancelSubmission
    
    var cancelSubmissionCalled = false
    
    func cancelSubmission() {
        cancelSubmissionCalled = true
    }
    
}

