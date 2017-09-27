//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostMenuModuleRouterInput {
    
    func openEdit(post: Post)
    func openReport(postHandle: PostHandle)
    func openReport(comment: Comment)
    func openReport(reply: Reply)
    func openLogin()
}

class PostMenuModuleRouter: PostMenuModuleRouterInput {
    
    weak var navigationController: UINavigationController?
    weak var loginOpener: LoginModalOpener?
    
    func openEdit(post: Post) {
        Logger.log(post.topicHandle)
        let vc = StoryboardScene.CreatePost.instantiateCreatePostViewController()
        let configurator = CreatePostModuleConfigurator()
        var user = User()
        user.uid = post.userHandle!
        user.firstName = post.firstName
        user.lastName = post.lastName
        configurator.configure(viewController: vc, user: user, post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openReport(postHandle: PostHandle) {
        let config = ReportConfigurator()
        let navController = UINavigationController(rootViewController: config.viewController)
        let api = ReportPostAPI(postID: postHandle, reportingService: ReportingService())
        config.configure(api: api,
                         navigationController: navController,
                         reportListTitle: L10n.Report.Post.headerTitle.uppercased())
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func openReport(comment: Comment) {
        let config = ReportConfigurator()
        let navController = UINavigationController(rootViewController: config.viewController)
        let api = ReportCommentAPI(commentID: comment.commentHandle, reportingService: ReportingService())
        config.configure(api: api,
                         navigationController: navController,
                         reportListTitle: L10n.Report.Comment.headerTitle.uppercased())
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func openReport(reply: Reply) {
        let config = ReportConfigurator()
        let navController = UINavigationController(rootViewController: config.viewController)
        let api = ReportReplyAPI(replyID: reply.replyHandle, reportingService: ReportingService())
        config.configure(api: api,
                         navigationController: navController,
                         reportListTitle: L10n.Report.Reply.headerTitle.uppercased())
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func openLogin() {
        loginOpener?.openLogin(parentViewController: navigationController)
    }

}
