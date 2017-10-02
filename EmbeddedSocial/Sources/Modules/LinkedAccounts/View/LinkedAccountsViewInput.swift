//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol LinkedAccountsViewInput: class {
    func setupInitialState()
    
    func setSwitchOn(_ isOn: Bool, for provider: AuthProvider)
    
    func setSwitchEnabled(_ isEnabled: Bool, for provider: AuthProvider)
    
    func showError(_ error: Error)
    
    func setSwitchesEnabled(_ isEnabled: Bool)
}
