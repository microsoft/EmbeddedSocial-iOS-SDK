//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol OutgoingCommandsUploadStrategyDelegate: class {
    func outgoingCommandsSubmissionDidFail(with error: Error)
}

protocol OutgoingCommandsUploadStrategyType {
    weak var delegate: OutgoingCommandsUploadStrategyDelegate? { get set }
    
    func restartSubmission()
    func cancelSubmission()
}

final class OutgoingCommandsUploadStrategy: OutgoingCommandsUploadStrategyType {
    
    private let executionQueue: OperationQueue
    private let cache: CacheType
    private let operationsBuilder: OutgoingCommandOperationsBuilderType
    private let predicateBuilder: OutgoingCommandsPredicateBuilder
    
    weak var delegate: OutgoingCommandsUploadStrategyDelegate?
    
    init(cache: CacheType,
         operationsBuilderType: OutgoingCommandOperationsBuilderType,
         executionQueue: OperationQueue,
         predicateBuilder: OutgoingCommandsPredicateBuilder = PredicateBuilder()) {
        
        self.cache = cache
        self.operationsBuilder = operationsBuilderType
        self.executionQueue = executionQueue
        self.predicateBuilder = predicateBuilder
    }
    
    func restartSubmission() {
        cancelSubmission()
        executePendingCommands()
    }
    
    func cancelSubmission() {
        executionQueue.cancelAllOperations()
    }
    
    private func executePendingCommands() {
        executeStep(.updateRelatedHandles)
    }
    
    private func executeStep(_ step: Step) {
        fetchCommands(with: step.predicate) { [weak self] commands in
            self?.executeCommands(commands) {
                if let next = step.next {
                    self?.executeStep(next)
                }
            }
        }
    }
    
    private func fetchCommands(with predicate: NSPredicate, completion: @escaping ([OutgoingCommand]) -> Void) {
        let fetchOperation = operationsBuilder.fetchCommandsOperation(cache: cache, predicate: predicate)
        
        fetchOperation.completionBlock = {
            guard !fetchOperation.isCancelled else {
                return
            }
            completion(fetchOperation.commands)
        }
        
        executionQueue.addOperation(fetchOperation)
    }
    
    private func executeCommands(_ commands: [OutgoingCommand], completion: @escaping () -> Void) {
        let operations = makeActionOperations(from: commands)
        let onSubmitted: Operation = BlockOperation { completion() }
        operations.forEach(onSubmitted.addDependency)
        executionQueue.addOperations(operations + [onSubmitted], waitUntilFinished: false)
    }
    
    private func makeActionOperations(from commands: [OutgoingCommand]) -> [Operation] {
        let operations = commands.flatMap { [weak self] command -> Operation? in
            let op = self?.operationsBuilder.operation(for: command)
            op?.completionBlock = {
                guard op?.isCancelled != true else {
                    return
                }
                
                let error = op?.error
                
                guard error == nil else {
                    DispatchQueue.main.async {
                        self?.delegate?.outgoingCommandsSubmissionDidFail(with: error!)
                    }
                    return
                }
                
                let predicate = self?.predicateBuilder.predicate(for: command) ?? NSPredicate()
                self?.cache.deleteOutgoing(with: predicate)
            }
            return op
        }
        
        return operations
    }
}

extension OutgoingCommandsUploadStrategy {
    final class Step {
        let predicate: NSPredicate
        let next: Step?
        
        init(predicate: NSPredicate, next: Step?) {
            self.predicate = predicate
            self.next = next
        }
    }
}

extension OutgoingCommandsUploadStrategy.Step {
    typealias Step = OutgoingCommandsUploadStrategy.Step
    
    static var updateRelatedHandles: Step {
        return Step(predicate: PredicateBuilder().updateRelatedHandleCommands(), next: removeTopics)
    }
    
    static var removeTopics: Step {
        return Step(predicate: PredicateBuilder().removeTopicCommands(), next: images)
    }
    
    static var images: Step {
        return Step(predicate: PredicateBuilder().allImageCommands(), next: createTopics)
    }
    
    static var createTopics: Step {
        return Step(predicate: PredicateBuilder().createTopicCommands(), next: topicActions)
    }
    
    static var topicActions: Step {
        return Step(predicate: PredicateBuilder().allTopicActionCommands(), next: createDeleteComments)
    }
    
    static var createDeleteComments: Step {
        return Step(predicate: PredicateBuilder().createDeleteCommentCommands(), next: commentActions)
    }
    
    static var commentActions: Step {
        return Step(predicate: PredicateBuilder().commentActionCommands(), next: createDeleteReplies)
    }
    
    static var createDeleteReplies: Step {
        return Step(predicate: PredicateBuilder().createDeleteReplyCommands(), next: replyActions)
    }
    
    static var replyActions: Step {
        return Step(predicate: PredicateBuilder().replyActionCommands(), next: userActions)
    }
    
    static var userActions: Step {
        return Step(predicate: PredicateBuilder().allUserCommands(), next: .notificationActions)
    }
    
    static var notificationActions: Step {
        return Step(predicate: PredicateBuilder().allNotificationCommands(), next: nil)
    }
}

extension OutgoingCommandsUploadStrategy.Step: Equatable {
    static func ==(lhs: OutgoingCommandsUploadStrategy.Step, rhs: OutgoingCommandsUploadStrategy.Step) -> Bool {
        return lhs.predicate == rhs.predicate && lhs.next == rhs.next
    }
}


