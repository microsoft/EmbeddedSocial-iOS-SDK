//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockCommentRepliesRouter: CommentRepliesRouterInput {
    
    //MARK: - openUser
    
    var openUserUserHandleFromCalled = false
    var openUserUserHandleFromReceivedArguments: (userHandle: UserHandle, view: UIViewController)?
    
    func openUser(userHandle: UserHandle, from view: UIViewController) {
        openUserUserHandleFromCalled = true
        openUserUserHandleFromReceivedArguments = (userHandle: userHandle, view: view)
    }
    
    //MARK: - openLogin
    
    var openLoginFromCalled = false
    var openLoginFromReceivedViewController: UIViewController?
    
    func openLogin(from viewController: UIViewController) {
        openLoginFromCalled = true
        openLoginFromReceivedViewController = viewController
    }
    
}
