//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

// TODO: remove modules buiding logic from here asap!

class SocialMenuItemsProvider: SideMenuItemsProvider {
    
    weak var delegate: CrossModuleCoordinator!
    
    init(delegate: CrossModuleCoordinator) {
        self.delegate = delegate
    }
    
    enum State: Int {
        case authenticated, unauthenticated
    }
    
    enum Route: Int {
        case home, signin, createPost = 6
    }
    
    var state: State {
        if delegate.isUserLoggedIn {
            return .authenticated
        } else {
            return .unauthenticated
        }
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
        
        guard let builder = items[state]?[index].builder else {
            return UIViewController()
        }
        
        return builder(self.delegate)
    }
    
    // TEMP
    @objc func testPush() {
        let config = CreatePostModuleConfigurator()
        let vc = StoryboardScene.CreatePost.instantiateCreatePostViewController()
        config.configure(viewController: vc, user: SocialPlus.shared.me, cache: SocialPlus.shared.cache)
        tempVC?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: Items
    
    typealias ModuleBuilder = (_ delegate: CrossModuleCoordinator) -> UIViewController

    
//    static var builderForSignIn: ModuleBuilder = { coordinator in
//        
//        let module = LoginConfigurator()
//        module.configure(moduleOutput: coordinator)
//        return module.viewController
//    }
    
    var builderForDummy: ModuleBuilder = { coordinator in
        let configurator = FeedModuleConfigurator()
        configurator.configure()
        return configurator.viewController
    }
    
    var builderForHome: ModuleBuilder = { coordinator in
        let configurator = FeedModuleConfigurator()
        configurator.configure()
        return configurator.viewController
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
