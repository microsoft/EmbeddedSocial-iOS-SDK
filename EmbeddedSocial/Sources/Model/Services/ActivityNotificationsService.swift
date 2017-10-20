//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityNotificationsServiceProtocol {
    func updateState(completion: @escaping ((Result<UInt32>) -> Void))
    func updateStatus(for handle: String, completion: ((Result<Void>) -> Void)?)
}

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
    
    func updateStatus(for handle: String, completion: ((Result<Void>) -> Void)?) {
        updateStatusForCompletionCalled = true
    }
    
}
class ActivityNotificationsService: BaseService, ActivityNotificationsServiceProtocol {
    
    private var outgoingActionsExecutor: OutgoingActionRequestExecutor!

    init(executorProvider provider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self) {
        super.init()
        outgoingActionsExecutor = provider.makeOutgoingActionRequestExecutor(for: self)
    }
    
    func updateState(completion: @escaping ((Result<UInt32>) -> Void)) {
        
        let builder = NotificationsAPI.myNotificationsGetNotificationsCountWithRequestBuilder(authorization: authorization)
        
        builder.execute { [weak self] (response, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            // get actual result
            guard let result64 = response?.body?.count, let result32 = UInt32(exactly: result64) else {
                
                // handle errors
                if strongSelf.errorHandler.canHandle(error) {
                    strongSelf.errorHandler.handle(error)
                } else {
                    completion(.failure(APIError(error: error)))
                }
                
                return
            }
            
            completion(.success(result32))
        }
    }
    
    func updateStatus(for handle: String, completion: ((Result<Void>) -> Void)? = nil) {
        let request = PutNotificationsStatusRequest()
        request.readActivityHandle = handle
        let builder = NotificationsAPI.myNotificationsPutNotificationsStatusWithRequestBuilder(request: request, authorization: authorization)
        
        let command = UpdateNotificationsStatusCommand(handle: handle)
        outgoingActionsExecutor.execute(command: command, builder: builder) {
            completion?($0)
        }
    }
}
