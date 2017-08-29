//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockSettingsView: SettingsViewInput {
    
    //MARK: - setSwitchIsOn
    
    var setSwitchIsOn_Called = false
    var setSwitchIsOn_ReceivedIsOn: Bool?
    
    func setSwitchIsOn(_ isOn: Bool) {
        setSwitchIsOn_Called = true
        setSwitchIsOn_ReceivedIsOn = isOn
    }
    
    //MARK: - showError
    
    var showError_Called = false
    var showError_ReceivedError: Error?
    
    func showError(_ error: Error) {
        showError_Called = true
        showError_ReceivedError = error
    }
    
    //MARK: - setPrivacySwitchEnabled
    
    var setPrivacySwitchEnabled_Called = false
    var setPrivacySwitchEnabled_ReceivedIsEnabled: Bool?
    
    func setPrivacySwitchEnabled(_ isEnabled: Bool) {
        setPrivacySwitchEnabled_Called = true
        setPrivacySwitchEnabled_ReceivedIsEnabled = isEnabled
    }
    
}
