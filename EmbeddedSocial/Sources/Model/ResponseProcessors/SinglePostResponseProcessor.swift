//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SinglePostResponseProcessor: ResponseProcessor<TopicView, Post> {
    
    private let queue: OperationQueue = {
        let q = OperationQueue()
        q.name = "SinglePostResponseProcessor-queue"
        q.qualityOfService = .userInitiated
        return q
    }()
    
    let cache: CacheType
    let operationsBuilder: OutgoingCommandOperationsBuilderType
    let predicateBuilder: TopicsFeedProcessorPredicateBuilder
    
    var commandsPredicate: NSPredicate {
        return predicateBuilder.topicActionsRemovedTopicsCreatedComments()
    }
    
    init(cache: CacheType,
         operationsBuilder: OutgoingCommandOperationsBuilderType = OutgoingCommandOperationsBuilder(),
         predicateBuilder: TopicsFeedProcessorPredicateBuilder = PredicateBuilder()) {
        
        self.cache = cache
        self.operationsBuilder = operationsBuilder
        self.predicateBuilder = predicateBuilder
    }
    
    override func process(_ response: TopicView?, isFromCache: Bool, completion: @escaping (Result<Post>) -> Void) {
        
        if let response = response {
            if let post = Post(data: response) {
                guard isFromCache else {
                    completion(.success(post))
                    return
                }
                
                applyTopicCommands(to: post) { processedTopic in
                    DispatchQueue.main.async {
                        completion(.success(processedTopic))
                    }
                }
            }
            else {
                completion(.failure(APIError.missingResponseData))
            }
        }
        else {
            completion(.failure(APIError.failedRequest))
        }
        
    }
    
    private func applyTopicCommands(to post: Post, completion: @escaping (Post) -> Void) {
        let fetchCommands = operationsBuilder.fetchCommandsOperation(cache: cache, predicate: commandsPredicate)
        
        fetchCommands.completionBlock = { [weak self] in
            guard let strongSelf = self, !fetchCommands.isCancelled else {
                completion(post)
                return
            }
            
            strongSelf.queue.addOperation {
                let commands = fetchCommands.commands as? [SingleTopicApplicableCommand] ?? []
                let list = strongSelf.apply(commands: commands, to: post)
                completion(list)
            }
        }
        
        queue.addOperation(fetchCommands)
    }
    
    func apply(commands: [SingleTopicApplicableCommand], to post: Post) -> Post {
        var post = post
        
        for command in commands {
            command.apply(to: &post)
        }
        
        return post
    }
}
