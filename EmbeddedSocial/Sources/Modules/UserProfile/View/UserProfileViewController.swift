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
private let navBarHeight: CGFloat = 64.0
private let feedHeight = UIScreen.main.bounds.height - filterHeight - navBarHeight

class UserProfileViewController: UIViewController {
    
    var output: UserProfileViewOutput!
    var feedModule: FeedModuleInput!
    
    @IBOutlet weak var containerScrollView: UIScrollView! {
        didSet {
            let contentHeight = headerHeight + filterHeight + feedHeight + containerInset * 2
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
        
        self.containerScrollView.addSubview(summaryView)
        
        summaryView.snp.makeConstraints { make in
            make.left.equalTo(self.containerScrollView)
            make.top.equalTo(self.containerScrollView).offset(containerInset)
            make.width.equalTo(contentWidth)
            make.height.equalTo(headerHeight)
        }
        
        return summaryView
    }()
    
    fileprivate lazy var filterView: SegmentedControlView = { [unowned self] in
        let filterView = SegmentedControlView.fromNib()
        filterView.setSegments([
            SegmentedControlView.Segment(title: "Recent posts", action: { self.output.onRecent() }),
            SegmentedControlView.Segment(title: "Popular posts", action: { self.output.onPopular() })
            ])
        filterView.selectSegment(0)
        filterView.isSeparatorHidden = false
        filterView.separatorColor = Palette.extraLightGrey
        
        self.containerScrollView.addSubview(filterView)
        filterView.snp.makeConstraints { make in
            make.left.equalTo(self.containerScrollView)
            make.top.equalTo(self.summaryView.snp.bottom).offset(containerInset).priority(.low)
            make.width.equalTo(contentWidth)
            make.height.equalTo(filterHeight)
            make.top.greaterThanOrEqualTo(self.view.snp.top)
        }
        
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
        configurator.configure(navigationController: self.navigationController!, moduleOutput: self)
        
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
//        feedView.isUserInteractionEnabled = false
        
        containerScrollView.addSubview(feedView)
        
        feedView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom)
            make.left.equalTo(containerScrollView)
            make.width.equalTo(summaryView.snp.width)
            make.height.equalTo(feedHeight)
        }
    }
    
    var lastTouchLocation: CGPoint = .zero
    
    var feedCollectionView: CollectionView?
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
        let isContainerScrolledAtMax = containerScrollView.contentOffset.y > headerHeight + containerInset * 2
        if isContainerScrolledAtMax {
            feedCollectionView?.isTrackingTouches = true
        }
    }
}

extension UserProfileViewController: FeedModuleOutput {
    
    func didScrollFeed(_ feedView: UIScrollView) {
        feedCollectionView = feedView as? CollectionView
        
        let touchLocation = feedView.panGestureRecognizer.translation(in: view)

        guard feedView.panGestureRecognizer.state == .changed else {
            lastTouchLocation = touchLocation
            return
        }
        
        let isContainerScrolledAtMax = containerScrollView.contentOffset.y > headerHeight + containerInset * 2
        let distance = lastTouchLocation.y - touchLocation.y
        let isScrollingUp = distance > 0
        
        print("isUp \(isScrollingUp) distance \(distance) container \(containerScrollView.contentOffset) lastOffset \(lastTouchLocation) containerOffset \(containerScrollView.contentOffset)")

        if isScrollingUp {
            if !isContainerScrolledAtMax {
                containerScrollView.contentOffset = CGPoint(x: containerScrollView.contentOffset.x,
                                                            y: containerScrollView.contentOffset.y + distance)
                feedView.contentOffset = .zero
                (feedView as? CollectionView)?.isTrackingTouches = false
            } else {
                (feedView as? CollectionView)?.isTrackingTouches = true
            }
        } else {
            if feedView.contentOffset.y <= 0 && containerScrollView.contentOffset.y > 0 {
                containerScrollView.contentOffset = CGPoint(x: containerScrollView.contentOffset.x,
                                                            y: containerScrollView.contentOffset.y + distance)
                feedView.contentOffset = .zero
                (feedView as? CollectionView)?.isTrackingTouches = false
            } else {
                (feedView as? CollectionView)?.isTrackingTouches = true
            }
        }
        
        lastTouchLocation = touchLocation
    }
}

class CollectionView: UICollectionView {
    
    var isTrackingTouches: Bool = true
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isTrackingTouches ? super.point(inside: point, with: event) : false
    }
}

class ScrollView: UIScrollView {
    var isTrackingTouches: Bool = true {
        didSet {
            print("isTrackingTouches \(isTrackingTouches)")
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isTrackingTouches ? super.point(inside: point, with: event) : false
    }
}
