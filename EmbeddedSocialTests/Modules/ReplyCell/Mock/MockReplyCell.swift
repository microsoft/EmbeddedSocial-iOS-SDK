//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockReplyCell: ReplyCellViewInput {
    
    var configureCount = 0
    func configure(reply: Reply) {
        configureCount += 1
    }
}
