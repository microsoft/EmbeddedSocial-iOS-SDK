//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockDetailedActivityRouter: DetailedActivityRouterInput {
    
    var openTopicCount = 0
    func openTopic(handle: String) {
        openTopicCount += 1
    }
    
    var openCommentCount = 0
    func openComment(handle: String) {
        openCommentCount += 1
    }
    
    var backCount = 0
    func back() {
        backCount += 1
    }
}
