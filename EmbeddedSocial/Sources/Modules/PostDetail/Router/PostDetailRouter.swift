//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import SKPhotoBrowser

class PostDetailRouter: PostDetailRouterInput {
    weak var navigationController: UINavigationController?
    
    func backIfNeeded(from view: UIViewController) {
        if view.navigationController?.viewControllers.last is CommentRepliesViewController  {
            view.navigationController?.popViewController(animated: true)
        }
    }
    
    func backToFeed(from view: UIViewController) {
        view.navigationController?.popViewController(animated: true)
    }
}
