//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class UserProfileViewController: BaseViewController {
    
    var output: UserProfileViewOutput!
    
    fileprivate lazy var moreButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(asset: .iconDots,
                               color: self.theme?.palette.navigationBarTint ?? Palette.defaultTint,
                               action: self.output.onMore)
    }()
    
    fileprivate lazy var feedLayoutButton: UIButton = { [unowned self] in
        return UIButton.makeButton(asset: nil,
                                   color: self.theme?.palette.navigationBarTint ?? Palette.defaultTint,
                                   action: self.output.onFlipFeedLayout)
    }()
    
    fileprivate lazy var headerView: UserProfileHeaderView = { [unowned self] in
        let view = UserProfileHeaderView(frame: .zero)
        view.onRecent = self.onRecent
        view.onPopular = self.onPopular
        view.summaryView.onEdit = self.output.onEdit
        view.summaryView.onFollowing = self.output.onFollowing
        view.summaryView.onFollow = { self.output.onFollowRequest(currentStatus: $0) }
        view.summaryView.onFollowers = self.output.onFollowers
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
    
    func setupInitialState(showGalleryView: Bool) {
        if showGalleryView {
            navigationItem.rightBarButtonItems = [moreButton, UIBarButtonItem(customView: self.feedLayoutButton)]
        } else {
            navigationItem.rightBarButtonItem = moreButton
        }
        apply(theme: theme)
    }
    
    func setFeedViewController(_ feedViewController: UIViewController) {
        addChildController(feedViewController, containerView: view)
        feedView = feedViewController.view
        view.bringSubview(toFront: stickyFilterView)
    }
    
    func setupHeaderView(_ reusableView: UICollectionReusableView) {
        guard headerView.superview == nil else {
            return
        }
        
        reusableView.backgroundColor = .clear
        reusableView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.FeedModule.Collection.containerPadding)
            make.right.equalToSuperview().offset(-Constants.FeedModule.Collection.containerPadding)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
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
        view.backgroundColor = palette.topicsFeedBackground
        feedLayoutButton.tintColor = palette.navigationBarTint
        stickyFilterView.apply(theme: theme)
        stickyFilterView.backgroundColor = theme?.palette.topicBackground
        stickyFilterView.separatorColor = theme?.palette.contentBackground
        headerView.apply(theme: theme)
    }
}
