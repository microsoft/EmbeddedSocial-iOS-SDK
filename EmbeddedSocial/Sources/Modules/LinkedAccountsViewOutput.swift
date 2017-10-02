//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol LinkedAccountsViewOutput: class {
    func viewIsReady()
    
    func onFacebookSwitchValueChanged(_ isOn: Bool)
    
    func onGoogleSwitchValueChanged(_ isOn: Bool)

    func onMicrosoftSwitchValueChanged(_ isOn: Bool)

    func onTwitterSwitchValueChanged(_ isOn: Bool)
}
