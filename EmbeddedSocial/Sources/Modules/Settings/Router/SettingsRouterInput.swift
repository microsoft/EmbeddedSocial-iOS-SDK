//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SettingsRouterInput: class {
    func openBlockedList()
    
    func openLinkedAccounts(sessionToken: String)
}
