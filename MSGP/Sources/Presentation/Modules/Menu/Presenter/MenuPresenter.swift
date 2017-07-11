//
//  MenuMenuPresenter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class MenuPresenter: MenuModuleInput, MenuViewOutput, MenuInteractorOutput {
    
    func needConfigureCell(path: IndexPath) -> MenuCellViewModel {
        return self.interactor.cellViewModel(path: path)
    }
    
    func didTapCell(path: IndexPath) {
        
    }
    
    weak var view: MenuViewInput!
    var interactor: MenuInteractorInput!
    var router: MenuRouterInput!

    func viewIsReady() {

    }
}
