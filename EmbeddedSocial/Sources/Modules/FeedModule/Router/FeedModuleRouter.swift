//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import SKPhotoBrowser

class FeedModuleRouter: FeedModuleRouterInput {
    
    weak var navigationController: UINavigationController?
    
    func open(route: FeedModuleRoutes) {
        
        switch route {
        case .profileDetailes(let userHandle):
            
            let configurator = UserProfileConfigurator()
            configurator.configure(userID: userHandle, navigationController: navigationController)
            
            navigationController?.pushViewController(configurator.viewController, animated: true)
        case .postDetails(let post):
            
            let configurator = PostDetailModuleConfigurator()
            configurator.configure(post: post)
            
            navigationController?.pushViewController(configurator.viewController, animated: true)
        case .openImage(let imageUrl):
            let photo = SKPhoto.photoWithImageURL(imageUrl)
            let browser = SKPhotoBrowser(photos: [photo])
            browser.initializePageIndex(0)
            navigationController?.present(browser, animated: true, completion: {})
        default:
            let dummy = UIViewController()
            dummy.view = UIView()
            dummy.view.backgroundColor = UIColor.yellow
            navigationController?.pushViewController(dummy, animated: true)
        }
    }
}
