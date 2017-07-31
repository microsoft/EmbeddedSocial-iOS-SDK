//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

final class LoginPresenter: LoginViewOutput {

    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    weak var moduleOutput: LoginModuleOutput?
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func onFacebookSignInTapped() {
        login(with: .facebook)
    }
    
    func onGoogleSignInTapped() {
        login(with: .google)
    }
    
    func onTwitterSignInTapped() {
        login(with: .twitter)
    }
    
    func onMicrosoftSignInTapped() {
        login(with: .microsoft)
    }
    
    private func login(with provider: AuthProvider) {
        view.setIsLoading(true)
        
        interactor.login(provider: provider, from: view as? UIViewController) { [weak self] result in
            if let user = result.value {
                self?.processUser(user)
            } else if let error = result.error {
                self?.view.setIsLoading(false)
                self?.view.showError(error)
            } else {
                fatalError("Unsupported response")
            }
        }
    }
    
    private func processUser(_ user: SocialUser) {
        interactor.getMyProfile(socialUser: user) { [weak self] result in
            self?.view.setIsLoading(false)
            
            if let (user, sessionToken) = result.value {
                self?.moduleOutput?.onSessionCreated(user: user, sessionToken: sessionToken)
            } else {
                self?.router.openCreateAccount(user: user)
            }
        }
    }
}

extension LoginPresenter: CreateAccountModuleOutput {
    func onAccountCreated(user: User, sessionToken: String) {
        moduleOutput?.onSessionCreated(user: user, sessionToken: sessionToken)
    }
}
