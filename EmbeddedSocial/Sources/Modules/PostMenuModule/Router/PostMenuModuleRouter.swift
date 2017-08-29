//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostMenuModuleRouterInput {
    
    func openEdit(post: Post)
    func openReport(post: Post)
    
}

class PostMenuModuleRouter: PostMenuModuleRouterInput {
    
    weak var navigationController: UINavigationController?
    
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
    
    func openReport(post: Post) {
        Logger.log(post.topicHandle)
    }

}
