//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockActivityNotificationsService: ActivityNotificationsServiceProtocol {
    
    //MARK: - updateState
    
    var updateStateCompletionCalled = false
    
    func updateState(completion: @escaping ((Result<UInt32>) -> Void)) {
        updateStateCompletionCalled = true
        
        let count = arc4random()
        let result: Result<UInt32> = .success(count)
        completion(result)
    }
    
    //MARK: - updateStatus
    
    var updateStatusForCompletionCalled = false
    var updateStatusForCompletionInputHandle: String?
    var updateStatusForCompletionResult: Result<Void>!
    
    func updateStatus(for handle: String, completion: ((Result<Void>) -> Void)?) {
        updateStatusForCompletionCalled = true
        updateStatusForCompletionInputHandle = handle
        completion?(updateStatusForCompletionResult)
    }

}
