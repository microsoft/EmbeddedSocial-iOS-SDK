//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

private let headerAspectRatio: CGFloat = 2.25

class UserProfileViewController: UIViewController {
    
    var output: UserProfileViewOutput!
    
    @IBOutlet fileprivate weak var loadingIndicatorView: LoadingIndicatorView! {
        didSet {
            loadingIndicatorView.apply(style: .standard)
        }
    }
    
    fileprivate lazy var summaryView: ProfileSummaryView = { [unowned self] in
        let summaryView = ProfileSummaryView.fromNib()
        let width = UIScreen.main.bounds.width
        summaryView.frame = CGRect(x: 0.0, y: 0.0, width: width, height: width / headerAspectRatio)
        summaryView.onEdit = { self.output.onEdit() }
        summaryView.onFollowing = { self.output.onFollowing() }
        summaryView.onFollow = { self.output.onFollowRequest(currentStatus: $0) }
        summaryView.onFollowers = { self.output.onFollowers() }
        return summaryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}

extension UserProfileViewController: UserProfileViewInput {
    func setupInitialState() {
        view.addSubview(summaryView)
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isHidden = !isLoading
        loadingIndicatorView.isLoading = isLoading
    }
    
    func setUser(_ user: User) {
        summaryView.configure(user: user)
    }
    
    func setFollowStatus(_ followStatus: FollowStatus) {
        summaryView.configure(followingStatus: followStatus)
    }
}
