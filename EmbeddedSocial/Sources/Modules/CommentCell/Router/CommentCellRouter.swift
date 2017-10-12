//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import SKPhotoBrowser

class CommentCellRouter: CommentCellRouterInput {
    
    var navigationController: UINavigationController?
    weak var postMenuModuleOutput: PostMenuModuleOutput!
    weak var moduleInput: CommentCellPresenter!
    
    // Keeping ref to menu
    private var postMenuViewController: UIViewController?
    
    func openReplies(scrollType: RepliesScrollType, commentModulePresenter: CommentCellModuleProtocol) {
        let configurator = CommentRepliesModuleConfigurator()
        
        configurator.configure(commentModule: commentModulePresenter,
                               scrollType: scrollType,
                               navigationController: navigationController)
        
        navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openUser(userHandle: String) {
        let configurator = UserProfileConfigurator()
        configurator.configure(userID: userHandle, navigationController: navigationController)
        
        navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openImage(imageUrl: String) {
        let browser = SKPhotoBrowser(photos: [SKPhoto.photoWithImageURL(imageUrl)])
        browser.initializePageIndex(0)
        
        navigationController?.present(browser, animated: true, completion: {})
    }
    
    func openLikes(commentHandle: String) {
        let configurator = LikesListConfigurator()
        configurator.configure(handle: commentHandle, type: .comment, navigationController: navigationController)
        navigationController?.pushViewController(configurator.viewController, animated: true)
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
                               moduleOutput: moduleInput,
                               navigationController: navigationController)
        postMenuViewController = configurator.viewController
        
        if let parent = navigationController?.viewControllers.last {
            postMenuViewController!.modalPresentationStyle = .overCurrentContext
            parent.present(postMenuViewController!, animated: false, completion: nil)
        }
    }
}
