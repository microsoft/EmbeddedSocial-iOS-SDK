//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import SKPhotoBrowser

class PostDetailRouter: PostDetailRouterInput {

    weak var navigationController: UINavigationController?
    
    func openUser(userHandle: UserHandle, from view: UIViewController) {
        let configurator = UserProfileConfigurator()
        configurator.configure(userID: userHandle)
        
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openReplies(comment: Comment, from view: UIViewController) {
        let configurator = CommentRepliesModuleConfigurator()
        configurator.configure(comment: comment)
        
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }

}
