//
//  TabMenuContainerTabMenuContainerPresenter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

enum TabMenuContainerTabs {
    case client, social
}

class TabMenuContainerPresenter: TabMenuContainerModuleInput, TabMenuContainerViewOutput, TabMenuContainerInteractorOutput {
    
    weak var view: TabMenuContainerViewInput!
    var interactor: TabMenuContainerInteractorInput!
    var router: TabMenuContainerRouterInput!

    func viewIsReady() {
        view.select(tab: .social)
    }
    
    func didSelect(tab: TabMenuContainerTabs) {
        interactor.configure(tab: tab)
    }
    
    func didConfigure(tab: UIViewController) {
        view.show(tab: tab)
    }
    
}
