//
//  MenuStackMenuStackPresenter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class MenuStackPresenter: MenuStackModuleInput, MenuStackViewOutput, MenuStackInteractorOutput {

    weak var view: MenuStackViewInput!
    var interactor: MenuStackInteractorInput!
    var router: MenuStackRouterInput!

    func viewIsReady() {

    }
}
