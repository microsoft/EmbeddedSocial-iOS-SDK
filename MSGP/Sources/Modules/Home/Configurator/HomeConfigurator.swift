//
//  HomeHomeConfigurator.swift
//  MSGP-Framework
//
//  Created by igor.popov on 24/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class HomeModuleConfigurator {
    
    class func configure() -> UIViewController {

        let viewController = StoryboardScene.Home.instantiateHomeViewController()
        let router = HomeRouter()

        let presenter = HomePresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = HomeInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        return viewController
    }
    
}
