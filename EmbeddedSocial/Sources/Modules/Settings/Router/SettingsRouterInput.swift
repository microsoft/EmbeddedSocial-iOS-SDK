//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum SettingsLinkRouter {
    case privacyPolicy
    case termsAndConditions
}

protocol SettingsRouterInput: class {
    func openBlockedList()
    
    func openLinkedAccounts(sessionToken: String)
    
    func openLink(type: SettingsLinkRouter)
}
