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
        case debug
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
    
    func imageHighlighted(forItem index: Int) -> UIImage {
        return items[state]![index].highlighted
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
    
    var builderForDebug: ModuleBuilder = { coordinator in
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        vc.title = "Debug"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { 
            SocialPlus.shared.logOut()
        })
        
        return vc
    }
    
    var builderForHome: ModuleBuilder = { $0.configuredHome }
    
    var builderForActivity: ModuleBuilder = { $0.configuredActivity }
    
    var builderForPopular: ModuleBuilder = { $0.configuredPopular }
    
    var builderForSearch: ModuleBuilder = { $0.configuredSearch }
    
    var builderForSettings: ModuleBuilder = { $0.configuredSettings }
    
    var builderForMyPins: ModuleBuilder = { $0.configuredMyPins }
    
    typealias MenuItem = (
        key: SocialItem,
        title: String,
        image: UIImage,
        highlighted: UIImage,
        builder: ModuleBuilder
    )
    
    func getMenuItemIndex(for item: SocialItem) -> Int? {
        return items[state]!.index(where: { $0.key == item })
    }
    
    lazy var items: [State: [MenuItem]] = { [unowned self] in
        
        return [
            State.authenticated: [
                (key: .home,
                 title: L10n.Home.screenTitle,
                 image: UIImage(asset: Asset.iconHome),
                 highlighted: UIImage(asset: Asset.iconHomeActive),
                 builder: self.builderForHome),
                (key: .search,
                 title: L10n.Search.screenTitle,
                 image: UIImage(asset: Asset.iconSearch),
                 highlighted: UIImage(asset: Asset.iconSearchActive),
                 builder: self.builderForSearch),
                (key: .popular,
                 title: L10n.Popular.screenTitle,
                 image: UIImage(asset: Asset.iconPopular),
                 highlighted: UIImage(asset: Asset.iconPopularActive),
                 builder: self.builderForPopular),
                (key: .myPins,
                 title: L10n.MyPins.screenTitle,
                 image: UIImage(asset: Asset.iconPins),
                 highlighted: UIImage(asset: Asset.iconPinsActive),
                 builder: self.builderForMyPins),
                (key: .activity,
                 title: L10n.ActivityFeed.screenTitle,
                 image: UIImage(asset: Asset.iconActivity),
                 highlighted: UIImage(asset: Asset.iconActivityActive),
                 builder: self.builderForActivity),
                (key: .settings,
                 title: L10n.Settings.screenTitle,
                 image: UIImage(asset: Asset.iconSettings),
                 highlighted: UIImage(asset: Asset.iconSettingsActive),
                 builder: self.builderForSettings)
                
            ],
            State.unauthenticated: [
                (key: .search, title: L10n.Search.screenTitle,
                 image: UIImage(asset: Asset.iconSearch),
                 highlighted: UIImage(asset: Asset.iconSearchActive),
                 builder: self.builderForSearch),
                (key: .popular, title: L10n.Popular.screenTitle,
                 image: UIImage(asset: Asset.iconPopular),
                 highlighted: UIImage(asset: Asset.iconPopularActive),
                 builder: self.builderForPopular)
            ]]
        
        }()
}
