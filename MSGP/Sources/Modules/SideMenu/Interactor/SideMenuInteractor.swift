//
//  SideMenuSideMenuInteractor.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class SideMenuInteractor: SideMenuInteractorInput {
    
    weak var output: SideMenuInteractorOutput!
    weak var clientMenuItemsProvider: SideMenuItemsProvider?
    weak var socialMenuItemsProvider: SideMenuItemsProvider!
    
    func socialMenuItems() -> [MenuItemModel] {
        
        var items = [MenuItemModel]()
        let count = socialMenuItemsProvider?.numberOfItems() ?? 0
        
        for index in 0..<count {
            let image = socialMenuItemsProvider!.image(forItem: index)
            let title = socialMenuItemsProvider!.title(forItem: index)
            items.append(MenuItemModel(title: title, image: image))
        }
        
        return items
    }
    
    func clientMenuItems() -> [MenuItemModel] {
        
        var items = [MenuItemModel]()
        let count = clientMenuItemsProvider?.numberOfItems() ?? 0
        
        for index in 0..<count {
            let image = clientMenuItemsProvider!.image(forItem: index)
            let title = clientMenuItemsProvider!.title(forItem: index)
            items.append(MenuItemModel(title: title, image: image))
        }
        
        return items
    }
    
    func targetForSocialMenuItem(with index: Int) -> UIViewController {
        return socialMenuItemsProvider!.destination(forItem: index)
    }
    
    func targetForClientMenuItem(with index: Int) -> UIViewController {
        return clientMenuItemsProvider!.destination(forItem: index)
    }
    
}
