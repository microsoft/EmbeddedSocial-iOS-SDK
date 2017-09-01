//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import SKPhotoBrowser

class CommentCellRouter: CommentCellRouterInput {
    
    var navigationController: UINavigationController?
    
    func openReplies(scrollType: RepliesScrollType, commentModulePresenter: CommentCellModuleProtocol) {
        let configurator = CommentRepliesModuleConfigurator()
        configurator.configure(commentModule: commentModulePresenter , scrollType: scrollType)
        
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
}
