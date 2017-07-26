//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

private let headerAspectRatio: CGFloat = 2.25

class UserProfileViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        automaticallyAdjustsScrollViewInsets = false
        setupTable()
    }
    
    private func setupTable() {
        let header = ProfileSummaryView.fromNib()
        header.frame = CGRect(x: 0.0,
                              y: 0.0,
                              width: tableView.frame.width,
                              height: tableView.frame.width / headerAspectRatio)
        tableView.tableHeaderView = header
        
        let user = User(uid: "",
                        firstName: "Sergei",
                        lastName: "Larionov",
                        email: nil,
                        bio: "Seattle-based designer, world-class dude.",
                        photo: Photo(image: UIImage(asset: .userPhotoPlaceholder)),
                        credentials: CredentialsList(provider: .facebook, accessToken: "", socialUID: ""),
                        followersCount: 12,
                        followingCount: 16,
                        visibility: ._public,
                        followingStatus: .blocked)
        header.configure(user: user)
    }
}
