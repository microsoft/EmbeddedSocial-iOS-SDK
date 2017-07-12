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
            
            MenuItemModel(title: "lel", pictureName: "icon_gear"),
            MenuItemModel(title: "hallo", pictureName: "icon_home")
            
        ]
    }()
    
    func retrieveMenuItems() {
        self.output.didRetrieveMenuItems(items: self.items)
    }

}
