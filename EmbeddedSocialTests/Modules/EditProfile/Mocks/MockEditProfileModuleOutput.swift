//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockEditProfileModuleOutput: EditProfileModuleOutput {
    private(set) var onProfileEditedCount = 0
    private(set) var me: User?
    
    func onProfileEdited(me: User) {
        self.me = me
        onProfileEditedCount += 1
    }
}
