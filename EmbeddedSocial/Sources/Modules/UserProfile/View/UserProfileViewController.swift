//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class UserProfileViewController: UIViewController {
    
    var output: UserProfileViewOutput!
    
    @IBOutlet fileprivate weak var loadingIndicatorView: LoadingIndicatorView! {
        didSet {
            loadingIndicatorView.apply(style: .standard)
        }
    }
    
    fileprivate lazy var createPostButton: BarButtonItemWithTarget = { [unowned self] in
        let button = BarButtonItemWithTarget()
        button.image = UIImage(asset: .iconDots)
        button.onTap = self.output.onMore
        return button
    }()
    
    fileprivate lazy var headerView: UserProfileHeaderView = { [unowned self] in
        let view = UserProfileHeaderView(frame: .zero)
        view.onRecent = self.output.onRecent
        view.onPopular = self.output.onPopular
        view.summaryView.onEdit = self.output.onEdit
        view.summaryView.onFollowing = self.output.onFollowing
        view.summaryView.onFollow = { self.output.onFollowRequest(currentStatus: $0) }
        view.summaryView.onFollowers = self.output.onFollowers
        return view
    }()
    
    fileprivate lazy var stickyFilterView: SegmentedControlView = { [unowned self] in
        let filterView = SegmentedControlView.fromNib()
        filterView.configureForUserProfileModule(superview: self.view,
                                                 onRecent: self.output.onRecent,
                                                 onPopular: self.output.onPopular)
        filterView.isHidden = true
        return filterView
    }()
    
    var summaryView: ProfileSummaryView {
        return headerView.summaryView
    }
    
    var filterView: SegmentedControlView {
        return headerView.filterView
    }
    
    fileprivate var feedView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}

extension UserProfileViewController: UserProfileViewInput {
    
    func setupInitialState() {
        parent?.navigationItem.rightBarButtonItem = createPostButton
        view.backgroundColor = Palette.extraLightGrey
    }
    
    func setFeedViewController(_ feedViewController: UIViewController) {
        feedViewController.willMove(toParentViewController: self)
        addChildViewController(feedViewController)
        feedViewController.didMove(toParentViewController: self)
        
        view.addSubview(feedViewController.view)
        
        feedViewController.view.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(Constants.UserProfile.containerInset)
            make.right.equalTo(self.view).offset(-Constants.UserProfile.containerInset)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        feedView = feedViewController.view
        
        view.bringSubview(toFront: stickyFilterView)
    }
    
    func setupHeaderView(_ reusableView: UICollectionReusableView) {
        guard headerView.superview == nil else {
            return
        }
        
        reusableView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoadingUser(_ isLoading: Bool) { }
    
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
    
    func setStickyFilterHidden(_ isHidden: Bool) {
        stickyFilterView.isHidden = isHidden
    }
    
    func setFollowingCount(_ followingCount: Int) {
        summaryView.followingCount = followingCount
    }
}
