//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

class CoreDataStackFactoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatStackIsCreated() {
        _ = CoreDataSetupHelper.makeInMemoryCoreDataStack()
    }
}
