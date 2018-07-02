//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateImageOperationTests: XCTestCase {
    
    var imageCache: MockImageCache!
    var service: MockImagesService!
    var cache: MockCache!
    var predicateBuilder: MockOutgoingCommandsPredicateBuilder!
    private var queue: OperationQueue!
    
    override func setUp() {
        super.setUp()
        
        cache = MockCache()
        imageCache = MockImageCache()
        service = MockImagesService()
        predicateBuilder = MockOutgoingCommandsPredicateBuilder()
        queue = OperationQueue()
    }
    
    override func tearDown() {
        super.tearDown()
        
        cache = nil
        imageCache = nil
        service = nil
        queue = nil
        predicateBuilder = nil
    }
    
    func executeOperationAndWait(_ operation: Operation) {
        queue.addOperation(operation)
        queue.waitUntilAllOperationsAreFinished()
    }
}
