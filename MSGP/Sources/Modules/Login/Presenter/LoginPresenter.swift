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
        interactor.login(provider: provider, from: view as? UIViewController) { [weak self] result in
            if let user = result.value {
                self?.router.openCreateAccount(user: user)
            } else if let error = result.error {
                self?.view.showError(error)
            } else {
                fatalError("Unsupported response")
            }
        }
    }
}

extension LoginPresenter: LoginModuleInput { }

extension LoginPresenter: CreateAccountModuleOutput {
    
    func onAccountCreated(result: Result<User>) {
        if let user = result.value {
            moduleOutput?.onLogin(user)
        } else if let error = result.error {
            view.showError(error)
        } else {
            fatalError("Unsupported response")
        }
    }
}
