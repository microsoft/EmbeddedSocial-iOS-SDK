//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SettingsPresenter {
    weak var view: SettingsViewInput!
    var router: SettingsRouterInput!
    
    fileprivate var myProfileHolder: UserHolder
    
    init(myProfileHolder: UserHolder) {
        self.myProfileHolder = myProfileHolder
    }
}

extension SettingsPresenter: SettingsViewOutput {
    
    func onBlockedList() {
        router.openBlockedList()
    }
    
    func onPrivacySwitch() {
        guard var user = myProfileHolder.me, let visibility = user.visibility else {
            return
        }
        
        user.visibility = visibility.switched
    }
}
