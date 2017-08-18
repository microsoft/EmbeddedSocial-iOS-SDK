//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SocialMenuItemsProvider: SideMenuItemsProvider {
    
    private weak var coordinator: CrossModuleCoordinatorProtocol!
    
    init(coordinator: CrossModuleCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    enum SocialItem: Int {
        case home
        case search
        case popular
        case myPins
        case activity
        case settings
    }
    
    enum State: Int {
        case authenticated, unauthenticated
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
    
    typealias ModuleBuilder = (_ delegate: CrossModuleCoordinatorProtocol) -> (UIViewController)
    
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

    typealias MenuItem = (key: SocialItem, title: String, image: UIImage, builder: ModuleBuilder)
    
    
    func getMenuItemIndex(for item: SocialItem) -> Int? {
        return items[state]!.index(where: { $0.key == item })
    }
    
    lazy var items: [State: [MenuItem]] = { [unowned self] in
        
        return [
            State.authenticated: [
                (key: .home,
                 title: L10n.Home.screenTitle,
                 image: UIImage(asset: Asset.iconHome),
                 builder: self.builderForHome),
                (key: .search,
                 title: L10n.Search.screenTitle,
                 image: UIImage(asset: Asset.iconSearch),
                 builder: self.builderForDummy),
                (key: .popular,
                 title: L10n.Popular.screenTitle,
                 image: UIImage(asset: Asset.iconPopular),
                 builder: self.builderForPopular),
                (key: .myPins, title: L10n.MyPins.screenTitle,
                 image: UIImage(asset: Asset.iconPins),
                 builder: self.builderForDummy),
                (key: .activity, title: L10n.ActivityFeed.screenTitle,
                 image: UIImage(asset: Asset.iconActivity),
                 builder: self.builderForDummy),
                (key: .settings, title: L10n.Settings.screenTitle,
                 image: UIImage(asset: Asset.iconSettings),
                 builder: self.builderForDummy)
            ],
            State.unauthenticated: [
                (key: .search, title: L10n.Search.screenTitle,
                 image: UIImage(asset: Asset.iconSearch),
                 builder: self.builderForDummy),
                (key: .popular, title: L10n.Popular.screenTitle,
                 image: UIImage(asset: Asset.iconPopular),
                 builder: self.builderForPopular)
            ]]
        
        }()
}
