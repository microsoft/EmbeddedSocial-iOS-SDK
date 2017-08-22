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
    
    func openReplies(commentView: CommentViewModel, scrollType: RepliesScrollType, from view: UIViewController, postDetailPresenter: PostDetailPresenter?) {
        let configurator = CommentRepliesModuleConfigurator()
        configurator.configure(commentView: commentView, scrollType: scrollType, postDetailsPresenter: postDetailPresenter)
        
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openImage(imageUrl: String, from view: UIViewController) {
        let browser = SKPhotoBrowser(photos: [SKPhoto.photoWithImageURL(imageUrl)])
        browser.initializePageIndex(0)
        view.present(browser, animated: true, completion: {})
    }

}
