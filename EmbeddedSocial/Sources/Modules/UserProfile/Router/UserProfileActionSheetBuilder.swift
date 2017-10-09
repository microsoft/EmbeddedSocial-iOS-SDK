//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct UserProfileActionSheetBuilder {
    
    static func makeMyActionsSheet(viewController: UIViewController,
                                   addPostHandler: @escaping () -> Void,
                                   followRequestsHandler: @escaping () -> Void) -> UIAlertController {
        
        let menu = makeDefaultController(presentingViewController: viewController)
        menu.addAction(UIAlertAction(title: L10n.UserProfile.Button.addPost, style: .default, handler: { _ in addPostHandler() }))
        menu.addAction(UIAlertAction(title: L10n.FollowRequests.screenTitle, style: .default, handler: { _ in followRequestsHandler() }))
        return menu
    }
    
    static func makeOtherUserActionsSheet(user: User,
                                          viewController: UIViewController,
                                          reportHandler: @escaping () -> Void,
                                          blockHandler: @escaping () -> Void) -> UIAlertController {
        
        let menu = makeDefaultController(presentingViewController: viewController)
        menu.addAction(UIAlertAction(title: L10n.UserProfile.Button.blockUser, style: .default, handler: { _ in blockHandler() }))
        menu.addAction(UIAlertAction(title: L10n.UserProfile.Button.reportUser, style: .default, handler: { _ in reportHandler() }))
        return menu
    }
    
    private static func makeDefaultController(presentingViewController: UIViewController) -> UIAlertController {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: L10n.Common.cancel, style: .cancel, handler: nil))
        
        if let controller = menu.popoverPresentationController {
            controller.sourceView = presentingViewController.view
            controller.sourceRect = presentingViewController.view.bounds
        }
        
        return menu
    }
}
