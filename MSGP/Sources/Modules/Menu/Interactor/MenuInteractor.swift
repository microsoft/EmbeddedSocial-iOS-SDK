//
//  MenuMenuInteractor.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class MenuInteractor: MenuInteractorInput {
    
    weak var output: MenuInteractorOutput!
    
    lazy var items: [MenuItemModel] = {
        return [
            
            MenuItemModel(title: "home", pictureName: "icon_gear", route: .home),
            MenuItemModel(title: "feed", pictureName: "icon_home", route: .feed)
            
        ]
    }()
    
    func retrieveMenuItems() {
        self.output.didRetrieveMenuItems(items: self.items)
    }

}
