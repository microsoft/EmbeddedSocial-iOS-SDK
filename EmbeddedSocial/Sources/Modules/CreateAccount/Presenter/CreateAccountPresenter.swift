//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CreateAccountPresenter: CreateAccountViewOutput {
    
    weak var view: CreateAccountViewInput!
    var interactor: CreateAccountInteractorInput!
    weak var moduleOutput: CreateAccountModuleOutput?
    var editModuleInput: EditProfileModuleInput!
    
    fileprivate let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func viewIsReady() {
        editModuleInput.setupInitialState()
        view.setupInitialState(with: editModuleInput.getModuleView())
    }
    
    func onCreateAccount() {
        editModuleInput.setIsLoading(true)
        
        interactor.createAccount(for: editModuleInput.getFinalUser()) { [weak self] result in
            self?.editModuleInput.setIsLoading(false)
            if let (user, sessionToken) = result.value {
                self?.moduleOutput?.onAccountCreated(user: user, sessionToken: sessionToken)
            } else if let error = result.error {
                self?.view.showError(error)
            }
        }
    }
}

extension CreateAccountPresenter: EditProfileModuleOutput {
    
    var viewController: UIViewController? {
        return view as? UIViewController
    }
    
    func setRightNavigationButtonEnabled(_ isEnabled: Bool) {
        view.setCreateAccountButtonEnabled(isEnabled)
    }
}
