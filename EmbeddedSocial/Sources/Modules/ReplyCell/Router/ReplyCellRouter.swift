//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ReplyCellRouterInput {
    func openUser(userHandle: String)
    func openLikes(replyHandle: String)
    func openMyReplyOptions(reply: Reply)
    func openOtherReplyOptions(reply: Reply)
    func openLogin()
}

class ReplyCellRouter: ReplyCellRouterInput {
    
    var loginOpener: LoginModalOpener?
    var navigationController: UINavigationController?
    weak var postMenuModuleOutput: PostMenuModuleOutput!
    weak var moduleInput: ReplyCellPresenter!
    
    private var postMenuViewController: UIViewController?
    
    func openUser(userHandle: String) {
        let configurator = UserProfileConfigurator()
        configurator.configure(userID: userHandle, navigationController: navigationController)
        
        navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openLikes(replyHandle: String) {
        let configurator = LikesListConfigurator()
        configurator.configure(handle: replyHandle, type: .reply, navigationController: navigationController)
        navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openMyReplyOptions(reply: Reply) {
        configureOptions(type: .myReply(reply: reply))
    }
    
    func openLogin() {
        loginOpener?.openLogin(parentViewController: navigationController)
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
