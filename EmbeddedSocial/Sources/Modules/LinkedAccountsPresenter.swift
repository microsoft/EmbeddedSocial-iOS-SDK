//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LinkedAccountsPresenter {
    
    weak var view: LinkedAccountsViewInput!
    var interactor: LinkedAccountsInteractorInput!
}

extension LinkedAccountsPresenter: LinkedAccountsViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        loadLinkedAccounts()
    }
    
    func loadLinkedAccounts() {
        view.setSwitchesEnabled(false)
        
        interactor.getLinkedAccounts { [weak self] accounts in
            self?.view.setSwitchesEnabled(true)
            
            if let accounts = accounts.value {
                for account in accounts {
                    self?.setLinkedAccount(account)
                }
            } else {
                self?.view.showError(accounts.error ?? APIError.unknown)
            }
        }
    }
    
    private func setLinkedAccount(_ linkedAccount: LinkedAccountView) {
        let switchSetters: [LinkedAccountView.IdentityProvider: (Bool) -> Void] = [
            .facebook: view.setFacebookSwitchOn,
            .google: view.setGoogleSwitchOn,
            .microsoft: view.setMicrosoftSwitchOn,
            .twitter: view.setTwitterSwitchOn
        ]
        
        if let indentityProvider = linkedAccount.identityProvider {
            switchSetters[indentityProvider]?(true)
        }
    }
}
