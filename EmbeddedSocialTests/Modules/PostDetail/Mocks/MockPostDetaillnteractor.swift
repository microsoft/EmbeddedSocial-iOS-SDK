//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockPostDetailsInteractor: PostDetailInteractor {
    
    override func fetchMoreComments(topicHandle: String) {
        output.didFetchMore(comments: [Comment()])
    }
    
}
