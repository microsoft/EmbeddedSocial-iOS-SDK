//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SettingsPresenter {
    weak var view: SettingsViewInput!
    var router: SettingsRouterInput!
    var interactor: SettingsInteractorInput!
    
    fileprivate var myProfileHolder: UserHolder
    fileprivate let sessionToken: String?
    
    init(myProfileHolder: UserHolder, sessionToken: String? = SocialPlus.shared.sessionToken) {
        self.myProfileHolder = myProfileHolder
        self.sessionToken = sessionToken
    }
}

extension SettingsPresenter: SettingsViewOutput {

    func viewIsReady() {
        let isOn = myProfileHolder.me?.visibility == ._private
        view.setSwitchIsOn(isOn)
    }
    
    func onBlockedList() {
        router.openBlockedList()
    }
    
    func signOut() {
        interactor.signOut()
    }
    
    func onPrivacySwitch() {
        guard var user = myProfileHolder.me, let visibility = user.visibility else {
            return
        }
        
        view.setPrivacySwitchEnabled(false)
        
        interactor.switchVisibility(visibility) { [weak self] result in
            self?.view.setPrivacySwitchEnabled(true)
            
            if let newVisibility = result.value {
                user.visibility = newVisibility
                self?.myProfileHolder.me = user
            } else {
                self?.view.showError(result.error ?? APIError.unknown)
            }
        }
    }
    
    func onLinkedAccounts() {
        guard let token = sessionToken else {
            return
        }
        router.openLinkedAccounts(sessionToken: token)
    }
}
