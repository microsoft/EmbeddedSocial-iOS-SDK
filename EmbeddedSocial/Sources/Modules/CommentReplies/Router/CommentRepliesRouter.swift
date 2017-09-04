//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CommentRepliesRouter: CommentRepliesRouterInput {
    func openUser(userHandle: UserHandle, from view: UIViewController) {
        let configurator = UserProfileConfigurator()
        configurator.configure(userID: userHandle, navigationController: view.navigationController)
        
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
}
