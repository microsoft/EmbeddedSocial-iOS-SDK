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
        interactor.getLinkedAccounts { [weak self] accounts in
            
        }
    }
}
