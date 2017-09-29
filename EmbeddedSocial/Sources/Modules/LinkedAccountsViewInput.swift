//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol LinkedAccountsViewInput: class {
    func setupInitialState()
    
    func setFacebookSwitchOn(_ isOn: Bool)
    
    func setGoogleSwitchOn(_ isOn: Bool)
    
    func setMicrosoftSwitchOn(_ isOn: Bool)
    
    func setTwitterSwitchOn(_ isOn: Bool)
    
    func showError(_ error: Error)
    
    func setSwitchesEnabled(_ isEnabled: Bool)
}
