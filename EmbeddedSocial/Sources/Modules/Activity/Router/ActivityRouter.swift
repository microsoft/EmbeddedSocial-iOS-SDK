//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityRouterInput {
    func open(with item: ActivityItem)
}

class ActivityRouter: ActivityRouterInput {
    
    var navigationController: UINavigationController!
    
    func open(with item: ActivityItem) {
        switch item {
        case let .myActivity(model):
            processActivityContent(model)
        case let .othersActivity(model):
            processActivityContent(model)
        default:
            return
        }
    }
    
    private func openViewController(_ vc: UIViewController) {
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func processActivityContent(_ model: ActivityView) {
        
        guard let contentType = model.actedOnContent?.contentType, let contentHandle = model.actedOnContent?.contentHandle else {
            return
        }
        
        switch contentType {
        case .comment:
            let vc = buildCommentVC(with: contentHandle)
            openViewController(vc)
        case .reply:
            let vc = buildReplyVC(with: contentHandle)
            openViewController(vc)
        case .topic:
            let vc = buildPostVC(with: contentHandle)
            openViewController(vc)
        default:
            Logger.log("Cant process", contentType, event: .veryImportant)
            return
        }
    }
    
    private func buildReplyVC(with handle: String) -> UIViewController {
        let vc = UIViewController()
        vc.title = "reply \(handle)"
        return vc
    }
    
    private func buildCommentVC(with handle: String) -> UIViewController {
//        let configurator = PostDetailModuleConfigurator()
//        return configurator.viewController
        let vc = UIViewController()
        vc.title = "comment \(handle)"
        return vc
    }
    
    private func buildPostVC(with handle: String) -> UIViewController {
//        let configurator = PostDetailModuleConfigurator()
//        return configurator.viewController
        let vc = UIViewController()
        vc.title = "post \(handle)"
        return vc
    }

}
