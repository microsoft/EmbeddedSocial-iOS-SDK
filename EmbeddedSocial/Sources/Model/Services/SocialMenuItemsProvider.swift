//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SocialMenuItemsProvider: SideMenuItemsProvider {
    
    private weak var coordinator: CrossModuleCoordinatorProtocol!
    
    init(delegate: CrossModuleCoordinatorProtocol) {
        self.coordinator = delegate
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
    
    
    var tempVC: UIViewController?
    func destination(forItem index: Int) -> UIViewController {
        return items[state]![index].builder(self.coordinator)
    }

    // MARK: Items
    
    typealias ModuleBuilder = (_ delegate: CrossModuleCoordinatorProtocol) -> ()
    
    var builderForDummy: ModuleBuilder = { coordinator in
        coordinator.openHomeScreen()
    }
    
    var builderForHome: ModuleBuilder = { coordinator in
       coordinator.openHomeScreen()
    }

    lazy var items: [State: [(title: String, image: UIImage, builder: ModuleBuilder)]] = { [unowned self] in
        
        return [State.authenticated: [
            (title: "Home", image: UIImage(asset: Asset.iconHome), builder: self.builderForHome),
            (title: "Search", image: UIImage(asset: Asset.iconSearch), builder: self.builderForDummy),
            (title: "Popular", image: UIImage(asset: Asset.iconPopular), builder: self.builderForDummy),
            (title: "My pins", image: UIImage(asset: Asset.iconPins), builder: self.builderForDummy),
            (title: "Activity Feed", image: UIImage(asset: Asset.iconActivity), builder: self.builderForDummy),
            (title: "Settings", image: UIImage(asset: Asset.iconSettings), builder: self.builderForDummy)
            ], State.unauthenticated: [
                (title: "Search", image: UIImage(asset: Asset.iconSearch), builder: self.builderForDummy),
                (title: "Popular", image: UIImage(asset: Asset.iconPopular), builder: self.builderForDummy)
            ]]
        
    }()
}
