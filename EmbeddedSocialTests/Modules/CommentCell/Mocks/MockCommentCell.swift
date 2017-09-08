//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentCellViewInput: CommentCellViewInput {
    
    //MARK: - configure
    
    var configureCommentCalled = false
    var configureCommentReceivedComment: Comment?
    
    func configure(comment: Comment) {
        configureCommentCalled = true
        configureCommentReceivedComment = comment
    }
    
    //MARK: - setupInitialState
    
    var setupInitialStateCalled = false
    
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
}
