//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreatePostRouter: CreatePostRouterInput {
    func back(from view: UIViewController) {
        guard let navigationContoller = view.navigationController else {
            assertionFailure("ViewController must have a NavigationController to pop (CreatePostRouterInput: back)")
            return
        }
        
        navigationContoller.popViewController(animated: true)
    }
}
