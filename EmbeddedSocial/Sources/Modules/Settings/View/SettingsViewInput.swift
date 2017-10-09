//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SettingsViewInput: class {
    func setSwitchIsOn(_ isOn: Bool)
    
    func showError(_ error: Error)
    
    func setPrivacySwitchEnabled(_ isEnabled: Bool)
}
