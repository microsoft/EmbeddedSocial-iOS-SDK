//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import SKPhotoBrowser

enum FeedModuleRoutes {
    
    case postDetails(post: PostViewModel)
    case myPost(post: Post)
    case othersPost(post: Post)
    case openImage(image: String)
    case comments(post: PostViewModel)
    case profileDetailes(user: UserHandle)
    case myProfile
}

protocol FeedModuleRouterInput {
    
    func open(route: FeedModuleRoutes, feedSource:FeedType)
    func open(route: FeedModuleRoutes, presenter: FeedModulePresenter)
}

class FeedModuleRouter: FeedModuleRouterInput {
    
    weak var viewController: UIViewController?
    weak var navigationController: UINavigationController? // Replace this with protocol
    weak var postMenuModuleOutput: PostMenuModuleOutput!
    weak var moduleInput: FeedModulePresenter!
    weak var myProfileOpener: MyProfileOpener?
    
    // Keeping ref to menu
    var postMenuViewController: UIViewController?
    
    func open(route: FeedModuleRoutes, presenter: FeedModulePresenter) {
        switch route {
        case .postDetails(let post):
        
            let configurator = PostDetailModuleConfigurator()
            configurator.configure(post: post, scrollType: .none, postPresenter: presenter)
            
            navigationController?.pushViewController(configurator.viewController, animated: true)
        case .comments(let post):
            
            let configurator = PostDetailModuleConfigurator()
            configurator.configure(post: post, scrollType: .bottom, postPresenter: presenter)
            
            navigationController?.pushViewController(configurator.viewController, animated: true)
        default: break     
        }
       
    }
    
    func open(route: FeedModuleRoutes, feedSource: FeedType) {
        
        switch route {
        case .profileDetailes(let userHandle):
            
            let configurator = UserProfileConfigurator()
            configurator.configure(userID: userHandle, navigationController: navigationController)
            
            navigationController?.pushViewController(configurator.viewController, animated: true)

        case .openImage(let imageUrl):
            let photo = SKPhoto.photoWithImageURL(imageUrl)
            let browser = SKPhotoBrowser(photos: [photo])
            browser.initializePageIndex(0)
            navigationController?.present(browser, animated: true, completion: {})
            
        case .othersPost(let post):
            
            let isHome = feedSource == .home
            let configurator = PostMenuModuleConfigurator()
            
            configurator.configure(menuType: .otherPost(post: post, isHome: isHome), moduleOutput: moduleInput)
            postMenuViewController = configurator.viewController
            
            if let parent = viewController {
                postMenuViewController!.modalPresentationStyle = .overCurrentContext
                parent.present(postMenuViewController!, animated: false, completion: nil)
            }
            
        case .myPost(let post):
            
            let configurator = PostMenuModuleConfigurator()
            
            configurator.configure(menuType: .myPost(post: post), moduleOutput: moduleInput)
            postMenuViewController = configurator.viewController
            
            if let parent = viewController {
                postMenuViewController!.modalPresentationStyle = .overCurrentContext
                parent.present(postMenuViewController!, animated: false, completion: nil)
            }
            
        case .myProfile:
            myProfileOpener?.openMyProfile()
            
        default:
            fatalError("Unexpected case")
        }
    }
}
