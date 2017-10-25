//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

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
