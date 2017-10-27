//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CommentRepliesRouter: CommentRepliesRouterInput {
    
    weak var navigationController: UINavigationController?
    
    func backIfNeeded(from view: UIViewController) {
        if !(view.navigationController?.viewControllers.last is CommentRepliesViewController) {
            view.navigationController?.popViewController(animated: true)
        }
    }
    
    func back() {
        if navigationController?.viewControllers.last is CommentRepliesViewController {
             navigationController?.popViewController(animated: true)
        }
    }
}
