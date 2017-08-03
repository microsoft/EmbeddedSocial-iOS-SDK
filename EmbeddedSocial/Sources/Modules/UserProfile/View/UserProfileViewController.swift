//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

private let headerAspectRatio: CGFloat = 2.25

class UserProfileViewController: UIViewController {
    
    var output: UserProfileViewOutput!
    var feedModule: FeedModuleInput!
    
    @IBOutlet fileprivate weak var container: UIView!
    
    @IBOutlet fileprivate weak var loadingIndicatorView: LoadingIndicatorView! {
        didSet {
            loadingIndicatorView.apply(style: .standard)
        }
    }
    
    fileprivate lazy var createPostButton: BarButtonItemWithTarget = { [unowned self] in
        let button = BarButtonItemWithTarget()
        button.image = UIImage(asset: .iconDots)
        button.onTap = {
            self.output.onMore()
        }
        return button
    }()
    
    fileprivate lazy var summaryView: ProfileSummaryView = { [unowned self] in
        let summaryView = ProfileSummaryView.fromNib()
        summaryView.onEdit = { self.output.onEdit() }
        summaryView.onFollowing = { self.output.onFollowing() }
        summaryView.onFollow = { self.output.onFollowRequest(currentStatus: $0) }
        summaryView.onFollowers = { self.output.onFollowers() }
        self.view.addSubview(summaryView)
        
        summaryView.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(summaryView.snp.width).dividedBy(headerAspectRatio)
        }
        
        return summaryView
    }()
    
    private var feedModuleInput: FeedModuleInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        // Module
        let configurator = FeedModuleConfigurator()
        configurator.configure(navigationController: self.navigationController!)
    
        feedModuleInput = configurator.moduleInput!
        let feedViewController = configurator.viewController!
        
        feedViewController.willMove(toParentViewController: self)
        addChildViewController(feedViewController)
        container.addSubview(feedViewController.view)
        
        feedViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        feedViewController.didMove(toParentViewController: self)
        
        let feed = FeedType.user(user: "3v9gnzwILTS", scope: .recent)
        feedModuleInput.setFeed(feed)
        
        // Sample for input change
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            let feed = FeedType.single(post: "3vErWk4EMrF")
            self.feedModuleInput.setFeed(feed)
            self.feedModuleInput.refreshData()
        }

    }
}

extension UserProfileViewController: UserProfileViewInput {
    func setupInitialState() {
        parent?.navigationItem.rightBarButtonItem = createPostButton
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isHidden = !isLoading
        loadingIndicatorView.isLoading = isLoading
        summaryView.isHidden = isLoading
    }
    
    func setUser(_ user: User) {
        summaryView.configure(user: user)
    }
    
    func setFollowStatus(_ followStatus: FollowStatus) {
        summaryView.configure(followStatus: followStatus)
    }
    
    func setIsProcessingFollowRequest(_ isLoading: Bool) {
        summaryView.isLoadingFollowStatus = isLoading
    }
    
    func setFollowersCount(_ followersCount: Int) {
        summaryView.followersCount = followersCount
    }
}
