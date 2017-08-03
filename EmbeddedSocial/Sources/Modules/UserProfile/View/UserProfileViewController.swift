//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

private let headerAspectRatio: CGFloat = 2.25
private let containerInset: CGFloat = 4.0

class UserProfileViewController: UIViewController {
    
    var output: UserProfileViewOutput!
    
    @IBOutlet fileprivate weak var containerScrollView: UIScrollView! {
        didSet {
            containerScrollView.contentSize = UIScreen.main.bounds.insetBy(dx: containerInset, dy: containerInset).size
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
            make.top.equalTo(self.containerScrollView).offset(4.0)
            make.width.equalTo(self.containerScrollView.snp.width)
            make.height.equalTo(summaryView.snp.width).dividedBy(headerAspectRatio)
        }
        
        return summaryView
    }()
    
    fileprivate lazy var filterView: UserProfileFilterView = { [unowned self] in
        let filterView = UserProfileFilterView.fromNib()
        self.containerScrollView.addSubview(filterView)
        
        filterView.snp.makeConstraints { make in
            make.left.equalTo(self.containerScrollView)
            make.top.equalTo(self.summaryView.snp.bottom).offset(4.0).priority(.low)
            make.top.greaterThanOrEqualTo(self.view)
//            make.width.equalTo(self.containerScrollView.snp.width)
            make.height.equalTo(44.0)
        }
        
        return filterView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}

extension UserProfileViewController: UserProfileViewInput {
    func setupInitialState() {
        parent?.navigationItem.rightBarButtonItem = createPostButton
        view.backgroundColor = Palette.extraLightGrey
        _ = filterView
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
