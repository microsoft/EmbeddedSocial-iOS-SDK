//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UserProfileRouter: UserProfileRouterInput {
    
    weak var viewController: UIViewController?

    func openFollowers(user: User) {
        let vc = UIViewController()
        vc.title = "Followers"
        vc.view.backgroundColor = .white
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openFollowing(user: User) {
        let vc = UIViewController()
        vc.title = "Following"
        vc.view.backgroundColor = .white
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openEditProfile(user: User) {
        let vc = UIViewController()
        vc.title = "Edit"
        vc.view.backgroundColor = .white
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
