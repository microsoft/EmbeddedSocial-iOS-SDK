//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SocialMenuItemsProvider: SideMenuItemsProvider {
    
    private weak var coordinator: CrossModuleCoordinatorProtocol!
    private let settings: Settings

    init(coordinator: CrossModuleCoordinatorProtocol, settings: Settings = AppConfiguration.shared.settings) {
        self.coordinator = coordinator
        self.settings = settings
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
        let home = self.makeSocialItem(.home, builder: self.builderForHome)
        let search = self.makeSocialItem(.search, builder: self.builderForSearch)
        let popular = self.makeSocialItem(.popular, builder: self.builderForPopular)
        let myPins = self.makeSocialItem(.myPins, builder: self.builderForMyPins)
        let activity = self.makeSocialItem(.activity, builder: self.builderForActivity)
        let settings = self.makeSocialItem(.settings, builder: self.builderForSettings)
        
        var authenticatedItems = [home, search, popular, myPins, activity, settings]
        var unauthenticatedItems = [search, popular]
        
        if !self.settings.searchEnabled {
            authenticatedItems.remove(at: 1)
            unauthenticatedItems.remove(at: 0)
        }
        
        return [.authenticated: authenticatedItems, .unauthenticated: unauthenticatedItems]
    }()
    
    private func makeSocialItem(_ item: SocialItem, builder: @escaping ModuleBuilder) -> MenuItem {
        return (key: item, title: item.title, image: item.image, highlighted: item.highlightedImage, builder: builder)
    }
}

enum SocialItem: Int {
    case home
    case search
    case popular
    case myPins
    case activity
    case settings
    
    var title: String {
        switch self {
        case .home:
            return L10n.Home.screenTitle
        case .search:
            return L10n.Search.screenTitle
        case .popular:
            return L10n.Popular.screenTitle
        case .myPins:
            return L10n.MyPins.screenTitle
        case .activity:
            return L10n.ActivityFeed.screenTitle
        case .settings:
            return L10n.Settings.screenTitle
        }
    }
    
    var image: UIImage {
        switch self {
        case .home:
            return UIImage(asset: .iconHome)
        case .search:
            return UIImage(asset: .iconSearch)
        case .popular:
            return UIImage(asset: .iconPopular)
        case .myPins:
            return UIImage(asset: .iconPins)
        case .activity:
            return UIImage(asset: .iconActivity)
        case .settings:
            return UIImage(asset: .iconSettings)
        }
    }
    
    var highlightedImage: UIImage {
        switch self {
        case .home:
            return UIImage(asset: .iconHomeActive)
        case .search:
            return UIImage(asset: .iconSearchActive)
        case .popular:
            return UIImage(asset: .iconPopularActive)
        case .myPins:
            return UIImage(asset: .iconPinsActive)
        case .activity:
            return UIImage(asset: .iconActivityActive)
        case .settings:
            return UIImage(asset: .iconSettingsActive)
        }
    }
}
