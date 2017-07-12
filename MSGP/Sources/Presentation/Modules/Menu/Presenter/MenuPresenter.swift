//
//  MenuMenuPresenter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class MenuPresenter: MenuModuleInput, MenuViewOutput, MenuInteractorOutput {
    
    func didTapCell(path: IndexPath) {
        router.openMenu(.feed)
    }
    
    weak var view: MenuViewInput!
    var interactor: MenuInteractorInput!
    var router: MenuRouterInput!

    func viewIsReady() {
        view.setupInitialState()
        interactor.retrieveMenuItems()
    }
    
    func didRetrieveMenuItems(items: [MenuItemModel]) {
        view.showMenu(with: items)
    }
    
}
