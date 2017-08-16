//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockEmbeddedEditProfileModuleOutput: EmbeddedEditProfileModuleOutput {
    var setRightNavigationButtonEnabledCount = 0
    var viewController: UIViewController?
    var isRightNavigationButtonEnabled: Bool?
    
    func setRightNavigationButtonEnabled(_ isEnabled: Bool) {
        setRightNavigationButtonEnabledCount += 1
        isRightNavigationButtonEnabled = isEnabled
    }
}
