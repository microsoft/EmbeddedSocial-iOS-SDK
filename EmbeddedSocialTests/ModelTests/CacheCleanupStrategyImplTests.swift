//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class CacheCleanupStrategyImplTests: XCTest {
    
    private var coreDataStack: CoreDataStack!
    private var sut: CacheCleanupStrategyImpl!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        
        let db = TransactionsDatabaseFacade(incomingRepo: CoreDataRepository(context: coreDataStack.mainContext),
                                            outgoingRepo: CoreDataRepository(context: coreDataStack.mainContext))
        let cache = Cache(database: db)
        sut = CacheCleanupStrategyImpl(cache: cache)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack.reset(onQueue: .main) { [weak self] _ in
            self?.coreDataStack = nil
        }
        sut = nil
    }
    
    
}
