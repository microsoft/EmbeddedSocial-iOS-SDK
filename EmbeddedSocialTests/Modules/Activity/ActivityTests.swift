//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ActivityEntitiesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testService() {
        
        // given
        
        let service = Service()
        
        let request: RequestBuilder<FeedResponseUserCompactView>? = service.builder(cursor: "safa", limit: 10)
        
        let a = 1
        
        
    }

}
