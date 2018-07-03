//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockSettingsView: SettingsViewInput {
    
    //MARK: - setSwitchIsOn
    
    var setSwitchIsOnCalled = false
    var setSwitchIsOnReceivedIsOn: Bool?
    
    func setSwitchIsOn(_ isOn: Bool) {
        setSwitchIsOnCalled = true
        setSwitchIsOnReceivedIsOn = isOn
    }
    
    //MARK: - showError
    
    var showErrorCalled = false
    var showErrorReceivedError: Error?
    
    func showError(_ error: Error) {
        showErrorCalled = true
        showErrorReceivedError = error
    }
    
    //MARK: - setPrivacySwitchEnabled
    
    var setPrivacySwitchEnabledCalled = false
    var setPrivacySwitchEnabledReceivedIsEnabled: Bool?
    
    func setPrivacySwitchEnabled(_ isEnabled: Bool) {
        setPrivacySwitchEnabledCalled = true
        setPrivacySwitchEnabledReceivedIsEnabled = isEnabled
    }
    
    //MARK: - setIsLoading
    
    var setIsLoadingCalled = false
    var setIsLoadingReceivedIsLoading: Bool?
    
    func setIsLoading(_ isLoading: Bool) {
        setIsLoadingCalled = true
        setIsLoadingReceivedIsLoading = isLoading
    }
    
}
