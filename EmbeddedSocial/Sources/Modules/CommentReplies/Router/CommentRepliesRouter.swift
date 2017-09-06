//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CommentRepliesRouter: CommentRepliesRouterInput {
    weak var loginOpener: LoginModalOpener?
        
    func openUser(userHandle: UserHandle, from view: UIViewController) {
        let configurator = UserProfileConfigurator()
        configurator.configure(userID: userHandle, navigationController: view.navigationController)
        
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openLikes(replyHandle: String, from view: UIViewController) {
        let configurator = LikesListConfigurator()
        configurator.configure(handle: replyHandle, type: .reply, navigationController: view.navigationController)
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openLogin(from viewController: UIViewController) {
        loginOpener?.openLogin(parentViewController: viewController.navigationController)
    }
}
