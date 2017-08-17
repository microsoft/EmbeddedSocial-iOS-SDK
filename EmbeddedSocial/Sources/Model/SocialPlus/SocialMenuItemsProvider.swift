//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SocialMenuItemsProvider: SideMenuItemsProvider {
    
    private weak var coordinator: CrossModuleCoordinator!
    
    init(coordinator: CrossModuleCoordinator) {
        self.coordinator = coordinator
    }
    
    enum State: Int {
        case authenticated, unauthenticated
    }
    
    enum Route: Int {
        case home, signin, createPost = 6
    }
    
    var state: State {
        return coordinator.isUserAuthenticated() ? .authenticated : .unauthenticated
    }
    
    func numberOfItems() -> Int {
        return items[state]!.count
    }
    
    func image(forItem index: Int) -> UIImage {
        return items[state]![index].image
    }
    
    func title(forItem index: Int) -> String {
        return items[state]![index].title
    }
    
    func destination(forItem index: Int) -> UIViewController {
        return items[state]![index].builder(self.coordinator)
    }

    // MARK: Items
    
    typealias ModuleBuilder = (_ delegate: CrossModuleCoordinator) -> (UIViewController)
    
    var builderForDummy: ModuleBuilder = { coordinator in
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        vc.title = "Dummy"
        return vc
    }
    
    var builderForHome: ModuleBuilder = { coordinator in
        return coordinator.configuredHome
    }
    
    var builderForPopular: ModuleBuilder = { coordinator in
        return coordinator.configuredPopular
    }
    
    var builderForPostMenu: ModuleBuilder = { coordinator in
        return coordinator.configuredDebug
    }

    lazy var items: [State: [(title: String, image: UIImage, builder: ModuleBuilder)]] = { [unowned self] in
        
        return [State.authenticated: [
            (title: L10n.Home.screenTitle, image: UIImage(asset: Asset.iconHome), builder: self.builderForHome),
            (title: L10n.Search.screenTitle, image: UIImage(asset: Asset.iconSearch), builder: self.builderForDummy),
            (title: L10n.Popular.screenTitle, image: UIImage(asset: Asset.iconPopular), builder: self.builderForPopular),
            (title: L10n.MyPins.screenTitle, image: UIImage(asset: Asset.iconPins), builder: self.builderForDummy),
            (title: L10n.ActivityFeed.screenTitle, image: UIImage(asset: Asset.iconActivity), builder: self.builderForDummy),
            (title: L10n.Settings.screenTitle, image: UIImage(asset: Asset.iconSettings), builder: self.builderForDummy),
            (title: L10n.SideMenu.debug, image: UIImage(asset: Asset.iconPrivate), builder: self.builderForPostMenu)
            ], State.unauthenticated: [
                (title: L10n.Search.screenTitle, image: UIImage(asset: Asset.iconSearch), builder: self.builderForDummy),
                (title: L10n.Popular.screenTitle, image: UIImage(asset: Asset.iconPopular), builder: self.builderForPopular)
            ]]
        
    }()
}
