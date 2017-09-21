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
    
    init(myProfileHolder: UserHolder) {
        self.myProfileHolder = myProfileHolder
    }
}

extension SettingsPresenter: SettingsViewOutput {

    func viewIsReady() {
        let isOn = myProfileHolder.me?.visibility == ._public
        view.setSwitchIsOn(isOn)
    }
    
    func onBlockedList() {
        router.openBlockedList()
    }
    
    func signOut() {
        interactor.signOut(success: { _ in
            self.router.logOut()
        }) { (error) in
            //TODO: handle
        }
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
}
