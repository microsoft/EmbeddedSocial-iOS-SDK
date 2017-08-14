//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class FeedModuleRouter: FeedModuleRouterInput {
    
    weak var viewController: UIViewController?
    weak var navigationController: UINavigationController?
    weak var postMenuModuleOutput: PostMenuModuleModuleOutput!
    weak var moduleInput: FeedModulePresenter!
    
    // Keeping ref to menu
    var postMenuViewController: UIViewController?
    
    func open(route: FeedModuleRoutes, feedSource: FeedType) {
        
        switch route {
        case .profileDetailes(let userHandle):
            
            let configurator = UserProfileConfigurator()
            configurator.configure(userID: userHandle)
            
            navigationController?.pushViewController(configurator.viewController, animated: true)
            
        case .othersPost(let post):
            
            let isHome = feedSource == .home
            let configurator = PostMenuModuleConfigurator()
            
            configurator.configure(menuType: .otherPost(post: post, isHome: isHome))
            postMenuViewController = configurator.viewController
            
            if let parent = viewController {
                postMenuViewController!.modalPresentationStyle = .overCurrentContext
                parent.present(postMenuViewController!, animated: false, completion: nil)
            }
            
        case .myPost(let post):
            
            let configurator = PostMenuModuleConfigurator()
            
            configurator.configure(menuType: .myPost(post: post))
            postMenuViewController = configurator.viewController
            
            if let parent = viewController {
                postMenuViewController!.modalPresentationStyle = .overCurrentContext
                parent.present(postMenuViewController!, animated: false, completion: nil)
            }

        default:
            let dummy = UIViewController()
            dummy.view = UIView()
            dummy.view.backgroundColor = UIColor.yellow
            navigationController?.pushViewController(dummy, animated: true)
        }
    }
}
