//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class AtomicOutgoingCommandsExecutor<ResponseType> {
    
    var cache: CacheType?
    var errorHandler: APIErrorHandler?
    private var commandBeingExecuted: OutgoingCommand?
    
    func execute(command: OutgoingCommand, builder: RequestBuilder<ResponseType>, completion: @escaping (Result<Void>) -> Void) {
        cacheCommand(command)
        completion(.success())
        runCommand(command, with: builder)
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
    
    private func runCommand(_ command: OutgoingCommand, with builder: RequestBuilder<ResponseType>) {
        commandBeingExecuted = command
        
        builder.execute { [weak self] response, error in
            DispatchQueue.main.async {
                self?.processResponse(response?.body, error)
            }
        }
    }
    
    private func processResponse(_ data: ResponseType?, _ error: Error?) {
        if let errorHandler = errorHandler, errorHandler.canHandle(error) {
            errorHandler.handle(error)
        } else if error == nil && commandBeingExecuted != nil {
            deleteCommand(commandBeingExecuted!)
        }
        commandBeingExecuted = nil
    }

}
