//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol DetailedActivityRouterInput {
    func openComment(handle: String)
    
    func openTopic(handle: String)
    
    func back()
}

class DetailedActivityRouter: DetailedActivityRouterInput {
    
    weak var navigationController: UINavigationController!
    
    func openTopic(handle: String) {
        let configurator = PostDetailModuleConfigurator()
        configurator.configure(topicHandle: handle, scrollType: .none, myProfileHolder: SocialPlus.shared, navigationController: navigationController)
        navigationController.pushViewController(configurator.viewController, animated: true)
    }
    
    func openComment(handle: String) {
        let configurator = DetailedActivityModuleConfigurator()
        configurator.configure(state: .comment, commentHandle: handle, navigationController: navigationController)
        navigationController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
