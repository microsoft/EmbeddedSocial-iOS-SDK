//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CommentRepliesRouter: CommentRepliesRouterInput {

    weak var loginOpener: LoginModalOpener?
    
    func openLogin(from viewController: UIViewController) {
        loginOpener?.openLogin(parentViewController: viewController.navigationController)
    }
    
    func backIfNeeded(from view: UIViewController) {
        if !(view.navigationController?.viewControllers.last is CommentRepliesViewController) {
            view.navigationController?.popViewController(animated: true)
        }
    }
}
