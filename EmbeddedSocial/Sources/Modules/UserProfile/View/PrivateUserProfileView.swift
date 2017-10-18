//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class PrivateUserProfileView: UIView {
    
    var output: UserProfileViewOutput?
    
    var user: User? {
        didSet {
            if let user = user {
                summaryView.configure(user: user)
                updateContentSize()
            }
        }
    }
    
    func apply(theme: Theme?) {
        backgroundColor = theme?.palette.topicsFeedBackground
        lockViewLabel.textColor = theme?.palette.topicSecondaryText
        summaryView.apply(theme: theme)
    }
    
    fileprivate lazy var scrollContainerView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        return scrollView
    }()
    
    fileprivate lazy var summaryView: ProfileSummaryView = { [unowned self] in
        let view = ProfileSummaryView.fromNib()
        view.onEdit = { [weak self] in self?.output?.onEdit() }
        view.onFollowing = { [weak self] in self?.output?.onFollowing() }
        view.onFollow = { [weak self] in self?.output?.onFollowRequest(currentStatus: $0) }
        view.onFollowers = { [weak self] in self?.output?.onFollowers() }
        self.scrollContainerView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.FeedModule.Collection.containerPadding)
            make.top.equalToSuperview().offset(Constants.FeedModule.Collection.containerPadding)
            make.width.equalTo(Constants.UserProfile.contentWidth)
            make.height.equalTo(0).priority(.low)
        }
        
        return view
    }()
    
    fileprivate lazy var lockView: UIView = { [unowned self] in
        let lock = UIImageView(image: UIImage(asset: .iconPrivate))
        let lockView = UIView()
        self.scrollContainerView.addSubview(lockView)
        lockView.addSubview(lock)
        lockView.addSubview(self.lockViewLabel)
        lock.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        self.lockViewLabel.snp.makeConstraints { make in
            make.top.equalTo(lock.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        lockView.snp.makeConstraints { make in
            make.centerX.equalTo(self.scrollContainerView)
            make.top.equalTo(self.summaryView.snp.bottom).offset(Constants.UserProfile.lockVerticalOffset)
        }
        return lockView
    }()
    
    fileprivate lazy var lockViewLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.text = L10n.UserProfile.privateFeed
        label.font = AppFonts.regular
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _ = summaryView
        _ = lockView
        updateContentSize()
    }
    
    private func updateContentSize() {
        let fittingSize = CGSize(width: Constants.UserProfile.contentWidth, height: .greatestFiniteMagnitude)
        let summaryHeight = summaryView.systemLayoutSizeFitting(fittingSize).height
        let extraBottomSpacing = UIScreen.main.bounds.height - Constants.UserProfile.summaryHeight
        scrollContainerView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: summaryHeight + extraBottomSpacing)
    }
}

