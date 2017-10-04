//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class UserProfileViewController: UIViewController {
    
    var output: UserProfileViewOutput!
    
    fileprivate lazy var createPostButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(asset: .iconDots, color: Palette.defaultTint, action: self.output.onMore)
    }()
    
    fileprivate lazy var feedLayoutButton: UIButton = { [unowned self] in
        return UIButton.makeButton(asset: nil, color: Palette.defaultTint, action: self.output.onFlipFeedLayout)
    }()
    
    fileprivate lazy var headerView: UserProfileHeaderView = { [unowned self] in
        let view = UserProfileHeaderView(frame: .zero)
        view.onRecent = self.onRecent
        view.onPopular = self.onPopular
        view.summaryView.onEdit = self.output.onEdit
        view.summaryView.onFollowing = self.output.onFollowing
        view.summaryView.onFollow = { self.output.onFollowRequest(currentStatus: $0) }
        view.summaryView.onFollowers = self.output.onFollowers
        view.snp.makeConstraints { make in
            make.width.equalTo(Constants.UserProfile.contentWidth)
        }
        return view
    }()
    
    fileprivate lazy var stickyFilterView: SegmentedControlView = { [unowned self] in
        let filterView = SegmentedControlView.fromNib()
        filterView.configureForUserProfileModule(superview: self.view, onRecent: self.onRecent, onPopular: self.onPopular)
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
        apply(theme: theme)
        output.viewIsReady()
    }
    
    private func onRecent() {
        stickyFilterView.selectSegment(Constants.UserProfile.recentSegment)
        filterView.selectSegment(Constants.UserProfile.recentSegment)
        output.onRecent()
    }
    
    private func onPopular() {
        stickyFilterView.selectSegment(Constants.UserProfile.popularSegment)
        filterView.selectSegment(Constants.UserProfile.popularSegment)
        output.onPopular()
    }
}

extension UserProfileViewController: UserProfileViewInput {
    
    var headerContentHeight: CGFloat {
        let size = CGSize(width: headerView.bounds.width, height: .greatestFiniteMagnitude)
        return headerView.systemLayoutSizeFitting(size).height
    }
    
    func setupInitialState() {
        view.backgroundColor = Palette.extraLightGrey
        navigationItem.rightBarButtonItems = [createPostButton, UIBarButtonItem(customView: self.feedLayoutButton)]
    }
    
    func setFeedViewController(_ feedViewController: UIViewController) {
        feedViewController.willMove(toParentViewController: self)
        addChildViewController(feedViewController)
        feedViewController.didMove(toParentViewController: self)
        
        view.addSubview(feedViewController.view)
        
        feedViewController.view.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(Constants.FeedModule.Collection.containerPadding)
            make.right.equalTo(self.view).offset(-Constants.FeedModule.Collection.containerPadding)
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
            make.height.equalTo(0).priority(.low)
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
    
    func setFilterEnabled(_ isEnabled: Bool) {
        filterView.isEnabled = isEnabled
        stickyFilterView.isEnabled = isEnabled
    }
    
    func setLayoutAsset(_ asset: Asset) {
        feedLayoutButton.setImage(UIImage(asset: asset), for: .normal)
        feedLayoutButton.sizeToFit()
    }
}

extension UserProfileViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        feedLayoutButton.tintColor = palette.navigationBarTint
        stickyFilterView.apply(theme: theme)
        headerView.apply(theme: theme)
        view.backgroundColor = palette.contentBackground
    }
}
































