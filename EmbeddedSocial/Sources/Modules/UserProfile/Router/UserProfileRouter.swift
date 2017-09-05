//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UserProfileRouter: UserProfileRouterInput {
    
    weak var viewController: UIViewController?
    weak var followersModuleOutput: FollowersModuleOutput?
    weak var followingModuleOutput: FollowingModuleOutput?
    weak var createPostModuleOutput: CreatePostModuleOutput?
    weak var editProfileModuleOutput: EditProfileModuleOutput?
    weak var loginOpener: LoginModalOpener?

    func openFollowers(user: User) {        
        let api: UsersListAPI = user.isMe ?
            MyFollowersAPI(service: SocialService()) :
            UserFollowersAPI(userID: user.uid, service: SocialService())
        
        let configurator = FollowersConfigurator()
        configurator.configure(api: api,
                               navigationController: viewController?.navigationController,
                               moduleOutput: followersModuleOutput)
        viewController?.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openFollowing(user: User) {
        let api: UsersListAPI = user.isMe ?
            MyFollowingAPI(service: SocialService()) :
            UserFollowingAPI(userID: user.uid, service: SocialService())
        
        let configurator = FollowingConfigurator()
        configurator.configure(api: api,
                               navigationController: viewController?.navigationController,
                               moduleOutput: followingModuleOutput)
        viewController?.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openEditProfile(user: User) {
        let configurator = EditProfileConfigurator()
        configurator.configure(user: user, moduleOutput: editProfileModuleOutput)
        viewController?.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openCreatePost(user: User) {
        let config = CreatePostModuleConfigurator()
        let vc = StoryboardScene.CreatePost.instantiateCreatePostViewController()
        config.configure(viewController: vc, user: user, moduleOutput: createPostModuleOutput)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openReport(user: User) {
        let config = ReportConfigurator()
        let navController = UINavigationController(rootViewController: config.viewController)
        let api = ReportUserAPI(userID: user.uid, reportingService: ReportingService())
        config.configure(api: api, navigationController: navController)
        viewController?.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func showMyMenu(_ addPostHandler: @escaping () -> Void) {
        guard let vc = viewController else {
            return
        }
        let menu = UserProfileActionSheetBuilder.makeMyActionsSheet(viewController: vc, addPostHandler: addPostHandler)
        vc.present(menu, animated: true, completion: nil)
    }
    
    func showUserMenu(_ user: User, blockHandler: @escaping () -> Void, reportHandler: @escaping () -> Void) {
        guard let vc = viewController else {
            return
        }
        let menu = UserProfileActionSheetBuilder.makeOtherUserActionsSheet(
            user: user,
            viewController: vc,
            reportHandler: reportHandler,
            blockHandler: blockHandler
        )
        vc.present(menu, animated: true, completion: nil)
    }
    
    func popTopScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func openLogin() {
        loginOpener?.openLogin(parentViewController: viewController?.navigationController)
    }
}
