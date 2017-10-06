//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockTrendingTopicsModuleOutput: TrendingTopicsModuleOutput {
    
    //MARK: - didSelectHashtag
    
    var didSelectHashtagCalled = false
    var didSelectHashtagReceivedHashtag: Hashtag?
    
    func didSelectHashtag(_ hashtag: Hashtag) {
        didSelectHashtagCalled = true
        didSelectHashtagReceivedHashtag = hashtag
    }
    
}
