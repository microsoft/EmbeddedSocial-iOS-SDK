//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias AtomicOutgoingCommandsExecutor = OutgoingCacheRequestExecutor<Object, Void>

class AtomicOutgoingCommandsExecutorImpl: OutgoingCacheRequestExecutor<Object, Void> {
    
    private var commandBeingExecuted: OutgoingCommand?
    
    override func execute(command: OutgoingCommand,
                          builder: RequestBuilder<Object>,
                          completion: @escaping (Result<Void>) -> Void) {
        
        cacheAndComplete(command: command, completion: completion)
        runCommand(command, with: builder, completion: completion)
    }
    
    func cacheAndComplete(command: OutgoingCommand, completion: @escaping (Result<Void>) -> Void) {
        cacheCommand(command)
        completion(.success())
    }
    
    private func cacheCommand(_ command: OutgoingCommand) {
        if let cachedInverseCommand = self.cachedInverseCommand(for: command) {
            deleteCommand(cachedInverseCommand)
        } else {
            cache?.cacheOutgoing(command)
        }
    }
    
    private func deleteCommand(_ command: OutgoingCommand) {
        cache?.deleteOutgoing(with: PredicateBuilder().predicate(for: command))
    }
    
    private func cachedInverseCommand(for command: OutgoingCommand) -> OutgoingCommand? {
        guard let inverseCommand = command.inverseCommand else {
            return nil
        }
        return cache?.firstOutgoing(ofType: type(of: inverseCommand),
                                    predicate: PredicateBuilder().predicate(for: inverseCommand),
                                    sortDescriptors: nil)
    }
    
    private func runCommand(_ command: OutgoingCommand, with builder: RequestBuilder<Object>, completion: @escaping (Result<Void>) -> Void) {
        commandBeingExecuted = command
        
        builder.execute { [weak self] response, error in
            DispatchQueue.main.async {
                self?.processResponse(response?.body, error, completion: completion)
            }
        }
    }
    
    private func processResponse(_ data: Object?, _ error: Error?, completion: @escaping (Result<Void>) -> Void) {
        if let errorHandler = errorHandler, errorHandler.canHandle(error) {
            errorHandler.handle(error)
        } else if error == nil && commandBeingExecuted != nil {
            deleteCommand(commandBeingExecuted!)
            onSuccess(completion: completion)
        }
        commandBeingExecuted = nil
    }
    
    func onSuccess(completion: @escaping (Result<Void>) -> Void) {
        
    }
}
