//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol OperationObserver: class {
    func observeOperation(_ op: Operation)
    func observeQueue(_ queue: OperationQueue)
}

extension OperationObserver where Self: NSObject {
    func observeOperation(_ op: Operation) {
        op.addObserver(self, forKeyPath: "isExecuting", options: .new, context: nil)
        op.addObserver(self, forKeyPath: "isCancelled", options: .new, context: nil)
        op.addObserver(self, forKeyPath: "isFinished", options: .new, context: nil)
        op.addObserver(self, forKeyPath: "isConcurrent", options: .new, context: nil)
        op.addObserver(self, forKeyPath: "isAsynchronous", options: .new, context: nil)
        op.addObserver(self, forKeyPath: "isReady", options: .new, context: nil)
        op.addObserver(self, forKeyPath: "name", options: .new, context: nil)
    }
    
    func observeQueue(_ queue: OperationQueue) {
        queue.addObserver(self, forKeyPath: "operations", options: .new, context: nil)
        queue.addObserver(self, forKeyPath: "operationCount", options: .new, context: nil)
        queue.addObserver(self, forKeyPath: "maxConcurrentOperationCount", options: .new, context: nil)
        queue.addObserver(self, forKeyPath: "isSuspended", options: .new, context: nil)
        queue.addObserver(self, forKeyPath: "name", options: .new, context: nil)
    }
}
