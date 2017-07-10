//
//  SignInSignInPresenter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class SignInPresenter: SignInModuleInput, SignInViewOutput, SignInInteractorOutput {

    weak var view: SignInViewInput!
    var interactor: SignInInteractorInput!
    var router: SignInRouterInput!

    func viewIsReady() {

    }
}
