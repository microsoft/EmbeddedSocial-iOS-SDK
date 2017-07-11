//
//  LoginLoginPresenter.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

final class LoginPresenter: LoginViewOutput {

    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    weak var moduleOutput: LoginModuleOutput?
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func onCreateAccountTapped() {
        router.openCreateAccount()
    }
    
    func onEmailSignInTapped() {
        router.openEmailSignIn()
    }
    
    func onFacebookSignInTapped() {
        login(with: .facebook)
    }
    
    func onGoogleSignInTapped() {
        
    }
    
    func onTwitterSignInTapped() {
        login(with: .twitter)
    }
    
    func onMicrosoftSignInTapped() {
        
    }
    
    private func login(with provider: AuthProvider) {
        interactor.login(provider: provider, from: view as? UIViewController) { [weak self] result in
            self?.moduleOutput?.onLogin(result)
        }
    }
}

extension LoginPresenter: LoginModuleInput { }

extension LoginPresenter: CreateAccountModuleOutput {
    
    func onAccountCreated(result: Result<User>) {
        moduleOutput?.onLogin(result)
    }
}
