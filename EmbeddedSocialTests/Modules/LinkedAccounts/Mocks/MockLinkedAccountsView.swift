//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockLinkedAccountsView: LinkedAccountsViewInput {
    
    //MARK: - setupInitialState
    
    var setupInitialStateCalled = false
    
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
    //MARK: - setSwitchOn
    
    var setSwitchOnForCalled = false
    var setSwitchOnForReceivedArguments: (isOn: Bool, provider: AuthProvider)?
    var setSwitchOnForAllReceivedArguments: [(isOn: Bool, provider: AuthProvider)?] = []

    func setSwitchOn(_ isOn: Bool, for provider: AuthProvider) {
        setSwitchOnForCalled = true
        setSwitchOnForReceivedArguments = (isOn: isOn, provider: provider)
        setSwitchOnForAllReceivedArguments.append(setSwitchOnForReceivedArguments)
    }
    
    //MARK: - setSwitchEnabled
    
    var setSwitchEnabledForCalled = false
    var setSwitchEnabledForReceivedArguments: (isEnabled: Bool, provider: AuthProvider)?
    
    func setSwitchEnabled(_ isEnabled: Bool, for provider: AuthProvider) {
        setSwitchEnabledForCalled = true
        setSwitchEnabledForReceivedArguments = (isEnabled: isEnabled, provider: provider)
    }
    
    //MARK: - showError
    
    var showErrorCalled = false
    var showErrorReceivedError: Error?
    
    func showError(_ error: Error) {
        showErrorCalled = true
        showErrorReceivedError = error
    }
    
    //MARK: - setSwitchesEnabled
    
    var setSwitchesEnabledCalled = false
    var setSwitchesEnabledReceivedIsEnabled: Bool?
    
    func setSwitchesEnabled(_ isEnabled: Bool) {
        setSwitchesEnabledCalled = true
        setSwitchesEnabledReceivedIsEnabled = isEnabled
    }
    
}
