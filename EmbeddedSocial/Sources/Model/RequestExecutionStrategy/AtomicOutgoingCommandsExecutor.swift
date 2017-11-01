//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class AtomicOutgoingCommandsExecutor<ResponseType> {
    
    var cache: CacheType?
    var errorHandler: APIErrorHandler?
    private var commandBeingExecuted: OutgoingCommand?
    
    func execute(command: OutgoingCommand,
                 builder: RequestBuilder<ResponseType>,
                 completion: @escaping (Result<Void>) -> Void) {
        
        commandBeingExecuted = command
        builder.execute { [weak self] response, error in
            DispatchQueue.main.async {
                self?.processResponse(response?.body, error, completion)
            }
        }
    }
    
    private func processResponse(_ data: ResponseType?, _ error: Error?, _ completion: @escaping (Result<Void>) -> Void) {
        if let errorHandler = errorHandler, errorHandler.canHandle(error) {
            errorHandler.handle(error)
        } else {
            if error != nil && commandBeingExecuted != nil {
                cacheCommand(commandBeingExecuted!)
            }
            completion(.success())
        }
        commandBeingExecuted = nil
    }
    
    private func cacheCommand(_ command: OutgoingCommand) {
        if let cachedInverseCommand = self.cachedInverseCommand(for: command) {
            cache?.deleteOutgoing(with: PredicateBuilder().predicate(for: cachedInverseCommand))
        } else {
            cache?.cacheOutgoing(command)
        }
    }
    
    private func cachedInverseCommand(for command: OutgoingCommand) -> OutgoingCommand? {
        guard let inverseCommand = command.inverseCommand else {
            return nil
        }
        return cache?.firstOutgoing(ofType: type(of: inverseCommand),
                                    predicate: PredicateBuilder().predicate(for: inverseCommand),
                                    sortDescriptors: nil)
    }

}
