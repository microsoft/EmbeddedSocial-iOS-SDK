//
//  UserProfileRouter.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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
