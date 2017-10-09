//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockDetailedActivityInteractor: DetailedActivityInteractorInput {
    weak var output: DetailedActivityInteractorOutput!
    
    func loadComment() {
        output.loaded(comment: Comment(commentHandle: UUID().uuidString))
    }
    
    func loadReply() {
        output.loaded(reply: Reply(replyHandle: UUID().uuidString))
    }
}
