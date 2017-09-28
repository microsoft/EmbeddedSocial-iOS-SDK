//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockFeedResponsePostProcessor: FeedResponsePostProcessorType {
    
    //MARK: - process
    
    var processCalled = false
    var processReceivedFeed: FeedFetchResult?
    
    func process(_ feed: inout FeedFetchResult) {
        processCalled = true
        processReceivedFeed = feed
    }
    
}
