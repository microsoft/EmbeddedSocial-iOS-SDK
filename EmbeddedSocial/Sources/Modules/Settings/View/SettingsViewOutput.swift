//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SettingsViewOutput: class {
    func viewIsReady()
    
    func onBlockedList()
    
    func onLinkedAccounts()

    func signOut()
    
    func onPrivacySwitch()
    
    func onPrivacyPolicy()
    
    func onTermsAndConditions()
    
    func onDeleteAccount()
}
