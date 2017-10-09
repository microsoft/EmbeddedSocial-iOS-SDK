//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

final class LoginPresenter: LoginViewOutput {

    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    weak var moduleOutput: LoginModuleOutput?
    
    fileprivate let source: SessionInfo.Source
    
    init(source: SessionInfo.Source) {
        self.source = source
    }
    
    func viewIsReady() {
        view.setupInitialState()
        if source == .modal {
            view.addLeftNavigationCancelButton()
        }
    }
    
    func onCancel() {
        router.dismiss()
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
            } else {
                self?.view.setIsLoading(false)
                self?.view.showError(result.error ?? APIError.unknown)
            }
        }
    }
    
    private func processUser(_ user: SocialUser) {
        interactor.getMyProfile(socialUser: user, from: view as? UIViewController) { [weak self] result in
            self?.view.setIsLoading(false)
            
            if let (user, sessionToken) = result.value {
                let sessionInfo = SessionInfo(user: user, token: sessionToken, source: self?.source ?? .menu)
                self?.moduleOutput?.onSessionCreated(with: sessionInfo)
            } else if user.credentials.provider == .twitter {
                self?.logIntoTwitter()
            } else {
                self?.router.openCreateAccount(user: User(socialUser: user))
            }
        }
    }
    
    /// Temporary solution that forces user to enter email / password twice.
    /// It will be removed after Twitter login flow will be refined on the server side.
    private func logIntoTwitter() {
        view.setIsLoading(true)

        interactor.login(provider: .twitter, from: view as? UIViewController) { [weak self] result in
            if let user = result.value {
                self?.router.openCreateAccount(user: User(socialUser: user))
            } else {
                self?.view.setIsLoading(false)
                self?.view.showError(result.error ?? APIError.unknown)
            }
        }
    }
}

extension LoginPresenter: CreateAccountModuleOutput {
    func onAccountCreated(user: User, sessionToken: String) {
        let sessionInfo = SessionInfo(user: user, token: sessionToken, source: source)
        moduleOutput?.onSessionCreated(with: sessionInfo)
    }
}
