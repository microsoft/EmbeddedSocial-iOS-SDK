//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol ActivityRouterInput {
    func open(with item: ActivityItem)
}

class ActivityRouter: ActivityRouterInput {
    
    var navigationController: UINavigationController!
    
    func open(with item: ActivityItem) {
        switch item {
        case let .myActivity(model):
            processActivity(model)
        case let .othersActivity(model):
            processActivity(model)
        default:
            return
        }
    }
    
    private func openViewController(_ vc: UIViewController) {
        navigationController.pushViewController(vc, animated: true)
    }
    
    // TODO: move out business logic from router to its consumer
    private func processContentActivity(type: ContentCompactView.ContentType, handle: String) {
    
        switch type {
        case .comment:
            let configurator = DetailedActivityModuleConfigurator()
            configurator.configure(state: .comment, commentHandle: handle, navigationController: navigationController)
            openViewController(configurator.viewController)
        case .reply:
            let configurator = DetailedActivityModuleConfigurator()
            configurator.configure(state: .reply, replyHandle: handle, navigationController: navigationController)
            openViewController(configurator.viewController)
        case .topic:
            let configurator = PostDetailModuleConfigurator()
            configurator.configure(topicHandle: handle, scrollType: .none, myProfileHolder: SocialPlus.shared, navigationController: navigationController)
            openViewController(configurator.viewController)
        default:
            Logger.log("Cant process", type, event: .veryImportant)
            return
        }
    }
    
    private func processUserActivity(handle: String) {
        let configurator = UserProfileConfigurator()
        configurator.configure(userID: handle, navigationController: navigationController)
        navigationController.pushViewController(configurator.viewController, animated: true)
    }

    private func processActivity(_ model: ActivityView) {
        if let contentType = model.actedOnContent?.contentType, let contentHandle = model.actedOnContent?.contentHandle {
            processContentActivity(type: contentType, handle: contentHandle)
        }
        else if let userHandle = model.actorUsers?.first?.userHandle {
            processUserActivity(handle: userHandle)
        }
        else {
            Logger.log(model, "Handle for this case is not implemented", event: .error)
        }
    }
}
