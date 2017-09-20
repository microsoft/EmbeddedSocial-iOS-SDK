//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class AsyncOperation: Operation {
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private let stateLock = NSLock()
    
    private var _executing: Bool = false
    
    override private(set) var isExecuting: Bool {
        get {
            return stateLock.withCriticalScope { _executing }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            stateLock.withCriticalScope { _executing = newValue }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return stateLock.withCriticalScope { _finished }
        }
        set {
            willChangeValue(forKey: "isFinished")
            stateLock.withCriticalScope { _finished = newValue }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    func completeOperation() {
        if isExecuting {
            isExecuting = false
        }
        
        if !isFinished {
            isFinished = true
        }
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        
        isExecuting = true
        
        main()
    }
    
    override func main() {
        fatalError("subclasses must override `main`")
    }
}

extension AsyncOperation {
    func completeIfNotCancelled() {
        if !isCancelled {
            completeOperation()
        }
    }
}
