//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class NonCachingAtomicOutgoingExecutor: AtomicOutgoingCommandsExecutorImpl {
    
    override func cacheAndComplete(command: OutgoingCommand, completion: @escaping (Result<Void>) -> Void) {
        
    }
    
    override func onSuccess(completion: @escaping (Result<Void>) -> Void) {
        completion(.success())
    }
}
