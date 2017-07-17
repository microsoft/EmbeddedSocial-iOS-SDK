//
//  CreatePostCreatePostRouter.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class CreatePostRouter: CreatePostRouterInput {
    func back(from view: UIViewController) {
        guard let navigationContoller = view.navigationController else {
            assertionFailure("ViewController must have a NavigationController to pop (CreatePostRouterInput: back)")
            return
        }
        
        navigationContoller.popViewController(animated: true)
    }
}
