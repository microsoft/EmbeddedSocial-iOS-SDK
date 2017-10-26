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
    case likesList(postHandle: String)
    case login
    case search(hashtag: String)
}

extension FeedModuleRoutes: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .postDetails:
            return "Post Details"
        case .myPost:
            return "My Post"
        case .othersPost:
            return "Others Post"
        case .openImage:
            return "Open Image"
        case .comments:
            return "Comments"
        case .profileDetailes:
            return "Profile Detailes"
        case .myProfile:
            return "My Profile"
        case .likesList:
            return "Likes List"
        case .login:
            return "Sign in"
        case .search:
            return "Search"
        }
    }
}

extension FeedModuleRoutes: Hashable {
    
    public var hashValue: Int {
        return self.description.hash
    }
    
}


protocol FeedModuleRouterInput {
    
    func open(route: FeedModuleRoutes, feedSource:FeedType)
    
}

/*
 For all router contributors:
 please keep router simple,
 move out all operatios related to configuration/initialization of modules/instances to external classes.
 
 Example 1: see "MyProfileOpener"
 Example 2:
 
 func open(route: FeedModuleRoutes) {
 let useCase = MyUseCase(route.arguments)
 useCase.execute()
 }
 
 */

class FeedModuleRouter: FeedModuleRouterInput {
    
    weak var viewController: UIViewController?
    weak var navigationController: UINavigationController?
    weak var postMenuModuleOutput: PostMenuModuleOutput!
    weak var moduleInput: FeedModulePresenter!
    weak var myProfileOpener: MyProfileOpener?
    weak var loginOpener: LoginModalOpener?
    weak var searchOpener: SearchHashtagOpener?
    
    // Keeping ref to menu module
    private var postMenuViewController: UIViewController?
    
    func open(route: FeedModuleRoutes, feedSource: FeedType) {
        
        Logger.log(route, event: .important)
        
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
            
            configurator.configure(menuType: .otherPost(post: post, isHome: isHome),
                                   moduleOutput: moduleInput,
                                   navigationController: navigationController)
            postMenuViewController = configurator.viewController
            
            
            if let parent = navigationController?.topViewController {
                postMenuViewController!.modalPresentationStyle = .overCurrentContext
                parent.present(postMenuViewController!, animated: true, completion: nil)
            }
            
        case .myPost(let post):
            
            let configurator = PostMenuModuleConfigurator()
            
            configurator.configure(menuType: .myPost(post: post), moduleOutput: moduleInput, navigationController: navigationController)
            postMenuViewController = configurator.viewController
            
            if let parent = viewController {
                postMenuViewController!.modalPresentationStyle = .overCurrentContext
                parent.present(postMenuViewController!, animated: false, completion: nil)
            }
            
        case .myProfile:
            myProfileOpener?.openMyProfile()
            
        case .likesList(let handle):
            let configurator = LikesListConfigurator()
            configurator.configure(handle: handle, type: .post, navigationController: navigationController)
            navigationController?.pushViewController(configurator.viewController, animated: true)
            
        case .postDetails(let post):
            
            let configurator = PostDetailModuleConfigurator()
            configurator.configure(topicHandle: post.topicHandle, scrollType: .none, navigationController: navigationController)
            
            navigationController?.pushViewController(configurator.viewController, animated: true)
        case .comments(let post):
            
            let configurator = PostDetailModuleConfigurator()
            configurator.configure(topicHandle: post.topicHandle, scrollType: .bottom, navigationController: navigationController)
            
            navigationController?.pushViewController(configurator.viewController, animated: true)
            
        case .login:
            loginOpener?.openLogin(parentViewController: navigationController)
            
        case .search(let hashtag):
            searchOpener?.openSearch(with: hashtag)
        }
    }
}
