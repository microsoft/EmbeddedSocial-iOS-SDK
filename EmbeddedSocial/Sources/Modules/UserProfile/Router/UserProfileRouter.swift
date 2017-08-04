//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UserProfileRouter: UserProfileRouterInput {
    
    weak var viewController: UIViewController?

    func openFollowers(user: User) {
        let api: UsersListAPI = user.isMe ?
            MyFollowersAPI(service: SocialService()) :
            UserFollowersAPI(userID: user.uid, service: SocialService())
        
        let configurator = FollowersConfigurator()
        configurator.configure(api: api)
        viewController?.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openFollowing(user: User) {
        let api: UsersListAPI = user.isMe ?
            MeFollowingAPI(service: SocialService()) :
            UserFollowingAPI(userID: user.uid, service: SocialService())
        
        let configurator = FollowingConfigurator()
        configurator.configure(api: api)
        viewController?.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openEditProfile(user: User) {
        let vc = UIViewController()
        vc.title = "Edit"
        vc.view.backgroundColor = .white
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openCreatePost(user: User) {
        let config = CreatePostModuleConfigurator()
        let vc = StoryboardScene.CreatePost.instantiateCreatePostViewController()
        config.configure(viewController: vc, user: user)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openReport(user: User) {
        let vc = UIViewController()
        vc.title = "Report \(user.fullName)"
        vc.view.backgroundColor = .white
        viewController?.navigationController?.pushViewController(vc, animated: true)
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
}
