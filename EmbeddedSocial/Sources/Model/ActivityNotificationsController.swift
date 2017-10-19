//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ActivityNotificationState {
    var count: UInt32 = 0
}

protocol ActivityNotificationsControllerProtocol {
    func update()
    func updateStatus(for handle: String)
}

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
        
        builder.execute { [weak self] (response, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            // handle errors
            if strongSelf.errorHandler.canHandle(error) {
                strongSelf.errorHandler.handle(error)
            } else {
                completion?(.failure(APIError(error: error)))
            }
            
            completion?(.success())
        }
    }
}

class ActivityNotificationsController {
    var state: ActivityNotificationState!
    var service: ActivityNotificationsServiceProtocol!

    func update() {
        service.updateState { [weak self] result in
            switch result {
            case .success(let count):
                self?.state.count = count
            case .failure(let error):
                Logger.log(error, event: .veryImportant)
            }
        }
    }
    
    func updateStatus(for handle: String) {
        service.updateStatus(for: handle, completion: nil)
    }
}
