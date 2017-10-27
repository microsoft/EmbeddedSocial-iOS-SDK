//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol SideMenuInteractorInput {
    func socialMenuItems() -> [SideMenuItemModelProtocol]
    func clientMenuItems() -> [SideMenuItemModelProtocol]
    func targetForSocialMenuItem(with index:Int) -> UIViewController
    func targetForClientMenuItem(with index:Int) -> UIViewController
    
    /* Misc */
    func getSocialItemIndex(for item: SocialItem) -> Int?
    
    /* Notifications  */
    func getNotificationsCount(onUpdated: @escaping () -> Void)
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
    var notificationsService: ActivityNotificationsServiceProtocol! = ActivityNotificationsService()
    
    private var notificationCountText: String?
    
    func socialMenuItems() -> [SideMenuItemModelProtocol] {
        
        var items = [SideMenuItemModelProtocol]()
        let count = socialMenuItemsProvider?.numberOfItems() ?? 0
        
        for index in 0..<count {
            
            let image = socialMenuItemsProvider!.image(forItem: index)
            let imageHighlighted = socialMenuItemsProvider!.imageHighlighted(forItem: index)
            let title = socialMenuItemsProvider!.title(forItem: index)
            
            let itemType = socialMenuItemsProvider.getType(by: index)
            
            switch itemType {
            case .activity:
                items.append(SideMenuItemModelWithNotification(title: title,
                                                               image: image,
                                                               imageHighlighted: imageHighlighted,
                                                               countText: notificationCountText))
            default:
                items.append(SideMenuItemModel(title: title,
                                               image: image,
                                               imageHighlighted: imageHighlighted))
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
    
    private func handleNotificationsUpdate(count: UInt32) {
        notificationCountText = stringFromNotificationsCount(count)
    }
    
    private func stringFromNotificationsCount(_ count: UInt32) -> String? {
        
        if count >= 1 && count <= 99 {
            return "\(count)"
        }
        else if count > 99 {
            return " 99+"
        }
        else {
            return nil
        }
    }
    
    func getNotificationsCount(onUpdated: @escaping () -> Void) {
        notificationsService.updateState { [weak self] result in
            
            guard let strongSelf = self, let count = result.value else {
                return
            }
            
            strongSelf.handleNotificationsUpdate(count: count)
            onUpdated()
        }
    }
    
}
