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
        view.onRecent = { [weak self] in self?.onRecent() }
        view.onPopular = { [weak self] in self?.onPopular() }
        view.summaryView.onEdit = { [weak self] in self?.output.onEdit() }
        view.summaryView.onFollowing = { [weak self] in self?.output.onFollowing() }
        view.summaryView.onFollow = { [weak self] in self?.output.onFollowRequest(currentStatus: $0) }
        view.summaryView.onFollowers = { [weak self] in self?.output.onFollowers() }
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
    
    @IBOutlet fileprivate var privateUserView: PrivateUserProfileView!
    
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
        return headerView.systemLayoutSizeFitting(size).height + Constants.UserProfile.containerInset
    }
    
    func setupInitialState(showGalleryView: Bool) {
        if showGalleryView {
            navigationItem.rightBarButtonItems = [moreButton, UIBarButtonItem(customView: self.feedLayoutButton)]
        } else {
            navigationItem.rightBarButtonItem = moreButton
        }
        apply(theme: theme)
        privateUserView.output = output
    }
    
    func setFeedViewController(_ feedViewController: UIViewController) {
        addChildController(feedViewController, containerView: view)
        feedView = feedViewController.view
        view.bringSubviewToFront(stickyFilterView)
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
            make.top.equalToSuperview().offset(Constants.FeedModule.Collection.containerPadding)
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
        privateUserView.user = user
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
    
    func setupPrivateAppearance() {
        guard privateUserView.superview == nil else {
            return
        }
        
        view.addSubview(privateUserView)
        privateUserView.snp.makeConstraints { $0.edges.equalToSuperview() }
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
        privateUserView.apply(theme: theme)
    }
}
