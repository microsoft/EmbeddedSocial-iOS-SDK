//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CommentRepliesRouter: CommentRepliesRouterInput {
    weak var loginOpener: LoginModalOpener?
    
    weak var postMenuModuleOutput: PostMenuModuleOutput!
    weak var moduleInput: CommentRepliesPresenter!
    
    // Keeping ref to menu
    private var postMenuViewController: UIViewController?
    
    func openUser(userHandle: UserHandle, from view: UIViewController) {
        let configurator = UserProfileConfigurator()
        configurator.configure(userID: userHandle, navigationController: view.navigationController)
        
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openLikes(replyHandle: String, from view: UIViewController) {
        let configurator = LikesListConfigurator()
        configurator.configure(handle: replyHandle, type: .reply, navigationController: view.navigationController)
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openLogin(from viewController: UIViewController) {
        loginOpener?.openLogin(parentViewController: viewController.navigationController)
    }
    
    func openMyReplyOptions(reply: Reply, from view: UIViewController) {
        configureOptions(type: .myReply(reply: reply), navigationController: view.navigationController)
    }
    
    func openOtherReplyOptions(reply: Reply, from view: UIViewController) {
        configureOptions(type: .otherReply(reply: reply), navigationController: view.navigationController)
    }
    
    private func configureOptions(type: PostMenuType, navigationController: UINavigationController?) {
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
