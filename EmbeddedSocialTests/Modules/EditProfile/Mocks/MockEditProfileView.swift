//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockEditProfileView: UIViewController, EditProfileViewInput {
    private(set) var setupInitialStateCount = 0
    private(set) var showErrorCount = 0
    private(set) var setSaveButtonEnabledCount = 0
    private(set) var setBackButtonEnabledCount = 0

    private(set) var editView: UIView?
    private(set) var lastShownError: Error?
    private(set) var isSaveButtonEnabled: Bool?
    private(set) var isBackButtonEnabled: Bool?
    
    func setupInitialState(with editView: UIView) {
        setupInitialStateCount += 1
        self.editView = editView
    }
    
    func showError(_ error: Error) {
        showErrorCount += 1
        lastShownError = error
    }
    
    func setSaveButtonEnabled(_ isEnabled: Bool) {
        setSaveButtonEnabledCount += 1
        isSaveButtonEnabled = isEnabled
    }
    
    func setBackButtonEnabled(_ isEnabled: Bool) {
        setBackButtonEnabledCount += 1
        isBackButtonEnabled = isEnabled
    }
}
