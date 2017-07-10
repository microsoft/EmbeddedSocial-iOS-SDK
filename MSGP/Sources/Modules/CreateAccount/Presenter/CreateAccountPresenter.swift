//
//  CreateAccountCreateAccountPresenter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class CreateAccountPresenter: CreateAccountModuleInput, CreateAccountViewOutput, CreateAccountInteractorOutput {

    weak var view: CreateAccountViewInput!
    var interactor: CreateAccountInteractorInput!
    var router: CreateAccountRouterInput!

    func viewIsReady() {

    }
}
