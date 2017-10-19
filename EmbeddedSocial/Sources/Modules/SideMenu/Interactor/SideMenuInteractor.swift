//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol SideMenuInteractorInput {
    func socialMenuItems() -> [SideMenuItemModelProtocol]
    func clientMenuItems() -> [SideMenuItemModelProtocol]
    func targetForSocialMenuItem(with index:Int) -> UIViewController
    func targetForClientMenuItem(with index:Int) -> UIViewController
    
    /* Misc */
    func getSocialItemIndex(for item: SocialItem) -> Int?
    
    /* Notifications  */
    func getNotificationsCount(completion: @escaping ((Result<UInt32>) -> Void))
}

protocol SideMenuInteractorOutput: class {
    
}

class SideMenuInteractor: SideMenuInteractorInput {
    
    func getSocialItemIndex(for item: SocialItem) -> Int? {
        return socialMenuItemsProvider.getMenuItemIndex(for: item)
    }
    
    weak var output: SideMenuInteractorOutput!
    weak var clientMenuItemsProvider: SideMenuItemsProvider?
    var socialMenuItemsProvider: SocialMenuItemsProvider!
    var notificationsService: ActivityNotificationsServiceProtocol! = MockActivityNotificationsService()
    
    func socialMenuItems() -> [SideMenuItemModelProtocol] {
        
        var items = [SideMenuItemModelProtocol]()
        let count = socialMenuItemsProvider?.numberOfItems() ?? 0
        
        for index in 0..<count {
            
            let image = socialMenuItemsProvider!.image(forItem: index)
            let imageHighlighted = socialMenuItemsProvider!.imageHighlighted(forItem: index)
            let title = socialMenuItemsProvider!.title(forItem: index)
            
            //
            if case let SocialItem.activity = socialMenuItemsProvider.getType(by: index) {
                items.append(SideMenuItemModelWithNotification(title: title, image: image, imageHighlighted: imageHighlighted))
            } else {
                items.append(SideMenuItemModel(title: title, image: image, imageHighlighted: imageHighlighted))
            }

        }
        
        return items
    }
    
    func clientMenuItems() -> [SideMenuItemModelProtocol] {
        
        var items = [SideMenuItemModelProtocol]()
        let count = clientMenuItemsProvider?.numberOfItems() ?? 0
        
        for index in 0..<count {
            let image = clientMenuItemsProvider!.image(forItem: index)
            let imageHighlighted = clientMenuItemsProvider!.imageHighlighted(forItem: index)
            let title = clientMenuItemsProvider!.title(forItem: index)
            items.append(SideMenuItemModel(title: title, image: image, imageHighlighted: imageHighlighted))
        }
        
        return items
    }
    
    func targetForSocialMenuItem(with index: Int) -> UIViewController {
        return socialMenuItemsProvider!.destination(forItem: index)
    }
    
    func targetForClientMenuItem(with index: Int) -> UIViewController {
        return clientMenuItemsProvider!.destination(forItem: index)
    }
    
    // MARK: Notifications
    
    func getNotificationsCount(completion: @escaping ((Result<UInt32>) -> Void)) {
        notificationsService.updateState(completion: completion)
    }
    
}
