//
//  LoginLoginPresenter.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

class LoginPresenter: LoginModuleInput, LoginViewOutput {

    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    weak var moduleOutput: LoginModuleOutput?
    
    private var password: String?
    private var email: String?

    func viewIsReady() {
        view.setupInitialState()
    }
    
    func onCreateAccountTapped() {
        router.openCreateAccount()
    }
    
    func onEmailChanged(_ text: String?) {
        email = text
    }
    
    func onPasswordChanged(_ text: String?) {
        password = text
    }
    
    func onLoginTapped() {
        interactor.login(email: email ?? "", password: password ?? "") { [weak self] result in
            self?.moduleOutput?.onLogin(result)
        }
    }
}

extension LoginPresenter: CreateAccountModuleOutput {
    
    func onAccountCreated(result: Result<User>) {
        moduleOutput?.onLogin(result)
    }
}
