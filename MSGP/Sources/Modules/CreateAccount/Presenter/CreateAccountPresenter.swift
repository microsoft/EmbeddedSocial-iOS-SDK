//
//  CreateAccountCreateAccountPresenter.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

class CreateAccountPresenter: CreateAccountViewOutput {

    weak var view: CreateAccountViewInput!
    var interactor: CreateAccountInteractorInput!
    var router: CreateAccountRouterInput!
    weak var moduleOutput: CreateAccountModuleOutput?

    func viewIsReady() {
        view.setupInitialState()
    }
    
//    func onCreateTapped() {
//        interactor.createAccount(email: email ?? "", password: password ?? "") { [weak self] result in
//            self?.moduleOutput?.onAccountCreated(result: result)
//        }
//    }
}
