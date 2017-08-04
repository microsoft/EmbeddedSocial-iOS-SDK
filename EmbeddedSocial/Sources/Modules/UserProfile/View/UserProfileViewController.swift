//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

private let headerAspectRatio: CGFloat = 2.25
private let containerInset: CGFloat = 6.0
private let filterHeight: CGFloat = 44.0
private let contentWidth = UIScreen.main.bounds.width - containerInset * 2
private let headerHeight = contentWidth / headerAspectRatio

class UserProfileViewController: UIViewController {
    
    var output: UserProfileViewOutput!
    var feedModule: FeedModuleInput!
    
    @IBOutlet weak var containerScrollView: UIScrollView! {
        didSet {
            containerScrollView.addSubview(summaryView)
            summaryView.snp.makeConstraints { make in
                make.left.equalTo(containerScrollView)
                make.top.equalTo(containerScrollView).offset(containerInset)
                make.width.equalTo(contentWidth)
                make.height.equalTo(headerHeight)
            }
            
            containerScrollView.addSubview(filterView)
            filterView.snp.makeConstraints { make in
                make.left.equalTo(containerScrollView)
                make.top.equalTo(summaryView.snp.bottom).offset(containerInset).priority(.medium)
                make.width.equalTo(contentWidth)
                make.height.equalTo(filterHeight)
                make.top.greaterThanOrEqualTo(containerScrollView.snp.top)
            }
            
            let navBarHeight: CGFloat = 64.0
            let feedHeight = UIScreen.main.bounds.height - filterHeight
            let contentHeight = headerHeight + filterHeight + feedHeight + containerInset * 2 - navBarHeight
            containerScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
            containerScrollView.delegate = self
        }
    }
    
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

        return summaryView
    }()
    
    fileprivate lazy var filterView: SegmentedControlView = { [weak self] in
        let filterView = SegmentedControlView.fromNib()
        filterView.setSegments([
            SegmentedControlView.Segment(title: "Recent posts", action: { self?.output.onRecent() }),
            SegmentedControlView.Segment(title: "Popular posts", action: { self?.output.onPopular() })
            ])
        filterView.selectSegment(0)
        filterView.isSeparatorHidden = false
        filterView.separatorColor = Palette.extraLightGrey
        return filterView
    }()
    
    private var feedModuleInput: FeedModuleInput!
    
    fileprivate var feedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    fileprivate func setupFeedModule() {
        let configurator = FeedModuleConfigurator()
        configurator.configure(navigationController: self.navigationController!)
        
        feedModuleInput = configurator.moduleInput!
        
        let feedViewController = configurator.viewController!
        
        feedViewController.willMove(toParentViewController: self)
        addChildViewController(feedViewController)
        feedViewController.didMove(toParentViewController: self)
        
        feedView = feedViewController.view
        feedModuleInput.setFeed(.user(user: "3v9gnzwILTS", scope: .recent))
        
        //        // Sample for input change
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        //
        //            let feed = FeedType.single(post: "3vErWk4EMrF")
        //            self.feedModuleInput.setFeed(feed)
        //            self.feedModuleInput.refreshData()
        //        }
    }
    
    fileprivate func setupFeedView() {
        containerScrollView.addSubview(feedView)
        
        feedView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom)
            make.left.equalTo(containerScrollView)
            make.width.equalTo(summaryView.snp.width)
            make.height.equalTo(UIScreen.main.bounds.height - filterHeight)
        }
    }
}

extension UserProfileViewController: UserProfileViewInput {
    func setupInitialState() {
        parent?.navigationItem.rightBarButtonItem = createPostButton
        view.backgroundColor = Palette.extraLightGrey
        setupFeedModule()
        setupFeedView()
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isHidden = !isLoading
        loadingIndicatorView.isLoading = isLoading
        containerScrollView.isHidden = isLoading
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

extension UserProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset, filterView.frame.origin)
    }
}
