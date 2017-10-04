//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockReplyCellInteractor: ReplyCellInteractorInput {
    
    weak var output: ReplyCellInteractorOutput!
    
    func replyAction(replyHandle: String, action: RepliesSocialAction) {
    }
    
    
}
