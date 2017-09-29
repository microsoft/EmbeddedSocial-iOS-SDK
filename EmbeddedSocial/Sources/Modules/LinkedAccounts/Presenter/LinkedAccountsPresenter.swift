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
        if let authProvider = linkedAccount.identityProvider?.authProvider {
            view.setSwitchOn(true, for: authProvider)
        }
    }
    
    func onFacebookSwitchValueChanged(_ isOn: Bool) {
        processSwitchValueChanged(isOn, provider: .facebook)
    }
    
    func onGoogleSwitchValueChanged(_ isOn: Bool) {
        processSwitchValueChanged(isOn, provider: .google)
    }
    
    func onMicrosoftSwitchValueChanged(_ isOn: Bool) {
        processSwitchValueChanged(isOn, provider: .microsoft)
    }
    
    func onTwitterSwitchValueChanged(_ isOn: Bool) {
        processSwitchValueChanged(isOn, provider: .twitter)
    }
    
    private func processSwitchValueChanged(_ isOn: Bool, provider: AuthProvider) {
        if isOn {
            linkAccount(with: provider)
        } else {
            deleteLinkedAccount(with: provider)
        }
    }
    
    private func linkAccount(with provider: AuthProvider) {
        view.setSwitchesEnabled(false)

        interactor.login(with: provider, from: view as? UIViewController) { [weak self] result in
            guard let authorization = result.value else {
                self?.view.showError(result.error ?? APIError.unknown)
                return
            }
            
            self?.interactor.linkAccount(authorization: authorization) { result in
                self?.view.setSwitchesEnabled(true)
                
                if let error = result.error {
                    self?.view.setSwitchOn(false, for: provider)
                    self?.view.showError(error)
                }
            }
        }
    }
    
    private func deleteLinkedAccount(with provider: AuthProvider) {
        view.setSwitchesEnabled(false)
        
        interactor.deleteLinkedAccount(provider: provider) { [weak self] result in
            self?.view.setSwitchesEnabled(true)
            
            if let error = result.error {
                self?.view.setSwitchOn(true, for: provider)
                self?.view.showError(error)
            }
        }
    }
}
