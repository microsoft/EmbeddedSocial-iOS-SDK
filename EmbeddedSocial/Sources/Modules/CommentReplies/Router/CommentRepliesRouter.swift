//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CommentRepliesRouter: CommentRepliesRouterInput {
    
    func backIfNeeded(from view: UIViewController) {
        if !(view.navigationController?.viewControllers.last is CommentRepliesViewController) {
            view.navigationController?.popViewController(animated: true)
        }
    }
}
