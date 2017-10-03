//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
@testable import EmbeddedSocial

final class MockCreateAccountViewController: UIViewController, CreateAccountViewInput {
    private(set) var setupInitialStateCount = 0
    private(set) var showErrorCount = 0
    private(set) var setCreateAccountButtonEnabledCount = 0
    
    private(set) var editView: UIView?
    private(set) var lastShownError: Error?
    private(set) var isCreateAccountButtonEnabled: Bool?
    
    func setupInitialState(with editView: UIView) {
        setupInitialStateCount += 1
        self.editView = editView
    }
    
    func showError(_ error: Error) {
        showErrorCount += 1
        lastShownError = error
    }
    
    func setCreateAccountButtonEnabled(_ isEnabled: Bool) {
        setCreateAccountButtonEnabledCount += 1
        isCreateAccountButtonEnabled = isEnabled
    }
}
