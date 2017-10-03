//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockReplyCellPresenter: ReplyCellViewOutput {
    
    var likeCount = 0
    func like() {
        likeCount += 1
    }
    
    var likesPressedCount = 0
    func likesPressed() {
        likesPressedCount += 1
    }
    
    var avatarPressedCount = 0
    func avatarPressed() {
        avatarPressedCount += 1
    }
    
    var optionsPressedCount = 0
    func optionsPressed() {
        optionsPressedCount += 1
    }
    
}
