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
        
        guard let builder = items[.authenticated]?[index].builder else {
            return UIViewController()
        }
        
        switch index {
        case Route.createPost.rawValue:
            // TEMP
            tempVC = UIViewController()
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            button.center = (tempVC?.view.center)!
            button.setTitle("push", for: .normal)
            button.addTarget(self, action: #selector(testPush), for: .touchUpInside)
            tempVC?.view.addSubview(button)
            return tempVC!
        default:
            return UIViewController()
        }
        
        return builder(self.delegate)
    }
    
    // TEMP
    @objc func testPush() {
        let config = CreatePostModuleConfigurator()
        let vc = StoryboardScene.CreatePost.instantiateCreatePostViewController()
        config.configure(viewController: vc, user: SocialPlus.shared.sessionStore.user, cache: SocialPlus.shared.cache)
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
    
    static var builderForDummy: ModuleBuilder = { coordinator in
        return HomeModuleConfigurator.configure()
    }
    
    static var builderForHome: ModuleBuilder = { coordinator in
        return HomeModuleConfigurator.configure()
    }
    
    var items = [State.authenticated: [
        (title: "Home", image: UIImage(asset: Asset.iconHome), builder: builderForHome),
        (title: "Search", image: UIImage(asset: Asset.iconSearch), builder: builderForDummy),
        (title: "Popular", image: UIImage(asset: Asset.iconPopular), builder: builderForDummy),
        (title: "My pins", image: UIImage(asset: Asset.iconPins), builder: builderForDummy),
        (title: "Activity Feed", image: UIImage(asset: Asset.iconActivity), builder: builderForDummy),
        (title: "Settings", image: UIImage(asset: Asset.iconSettings), builder: builderForDummy),
        (title: "Create post", image: UIImage(asset: Asset.iconSettings), builder: builderForDummy)
        ], State.unauthenticated: [
            (title: "Search", image: UIImage(asset: Asset.iconSearch), builder: builderForDummy),
            (title: "Popular", image: UIImage(asset: Asset.iconPopular), builder: builderForDummy)
        ]]
}
