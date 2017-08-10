//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct UserProfileActionSheetBuilder {
    
    static func makeMyActionsSheet(viewController: UIViewController, addPostHandler: @escaping () -> Void) -> UIAlertController {
        let menu = makeDefaultController(presentingViewController: viewController)
        menu.addAction(UIAlertAction(title: "Add post", style: .default, handler: { _ in addPostHandler() }))
        return menu
    }
    
    static func makeOtherUserActionsSheet(user: User,
                                          viewController: UIViewController,
                                          reportHandler: @escaping () -> Void,
                                          blockHandler: @escaping () -> Void) -> UIAlertController {
        
        let menu = makeDefaultController(presentingViewController: viewController)
        menu.addAction(UIAlertAction(title: "Block user", style: .default, handler: { _ in blockHandler() }))
        menu.addAction(UIAlertAction(title: "Report user", style: .default, handler: { _ in reportHandler() }))
        return menu
    }
    
    private static func makeDefaultController(presentingViewController: UIViewController) -> UIAlertController {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let controller = menu.popoverPresentationController {
            controller.sourceView = presentingViewController.view
            controller.sourceRect = presentingViewController.view.bounds
        }
        
        return menu
    }
}
