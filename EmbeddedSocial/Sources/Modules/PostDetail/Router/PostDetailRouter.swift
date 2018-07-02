//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import SKPhotoBrowser

class PostDetailRouter: PostDetailRouterInput {
    weak var navigationController: UINavigationController?
    weak var postMenuModuleOutput: PostMenuModuleOutput!
    weak var moduleInput: PostDetailPresenter!
    
    // Keeping ref to menu
    private var postMenuViewController: UIViewController?
    
    func backIfNeeded(from view: UIViewController) {
        if view.navigationController?.viewControllers.last is CommentRepliesViewController  {
            view.navigationController?.popViewController(animated: true)
        }
    }
    
    func backToFeed(from view: UIViewController) {
        view.navigationController?.popViewController(animated: true)
    }
    
    func openMyCommentOptions(comment: Comment) {
        configureOptions(type: .myComment(comment: comment))
    }
    
    func openOtherCommentOptions(comment: Comment) {
        configureOptions(type: .otherComment(comment: comment))
    }
    
    private func configureOptions(type: PostMenuType) {
        let configurator = PostMenuModuleConfigurator()
        
        configurator.configure(menuType: type,
                               moduleOutput: moduleInput as! PostMenuModuleOutput,
                               navigationController: navigationController)
        postMenuViewController = configurator.viewController
        
        if let parent = navigationController?.viewControllers.last {
            postMenuViewController!.modalPresentationStyle = .overCurrentContext
            parent.present(postMenuViewController!, animated: false, completion: nil)
        }
    }
}
