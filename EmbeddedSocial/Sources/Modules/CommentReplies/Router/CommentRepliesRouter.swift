//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CommentRepliesRouter: CommentRepliesRouterInput {
    
    weak var navigationController: UINavigationController?
    
    weak var postMenuModuleOutput: PostMenuModuleOutput!
    weak var moduleInput: CommentRepliesPresenter!
    
    // Keeping ref to menu
    private var postMenuViewController: UIViewController?
    
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
    
    func openMyReplyOptions(reply: Reply) {
        configureOptions(type: .myReply(reply: reply))
    }
    
    func openOtherReplyOptions(reply: Reply) {
        configureOptions(type: .otherReply(reply: reply))
    }
    
    private func configureOptions(type: PostMenuType) {
        let configurator = PostMenuModuleConfigurator()
        
        configurator.configure(menuType: type,
                               moduleOutput: moduleInput,
                               navigationController: navigationController)
        postMenuViewController = configurator.viewController
        
        if let parent = navigationController?.viewControllers.last {
            postMenuViewController!.modalPresentationStyle = .overCurrentContext
            parent.present(postMenuViewController!, animated: false, completion: nil)
        }
    }
}
