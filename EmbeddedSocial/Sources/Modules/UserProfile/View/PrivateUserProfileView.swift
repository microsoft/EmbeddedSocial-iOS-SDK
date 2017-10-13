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
            }
        }
    }
    
    func apply(theme: Theme?) {
        backgroundColor = theme?.palette.topicsFeedBackground
        summaryView.apply(theme: theme)
    }
    
    fileprivate lazy var summaryView: ProfileSummaryView = { [unowned self] in
        let view = ProfileSummaryView.fromNib()
        view.onEdit = { [weak self] in self?.output?.onEdit() }
        view.onFollowing = { [weak self] in self?.output?.onFollowing() }
        view.onFollow = { [weak self] in self?.output?.onFollowRequest(currentStatus: $0) }
        view.onFollowers = { [weak self] in self?.output?.onFollowers() }
        self.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.FeedModule.Collection.containerPadding)
            make.right.equalToSuperview().offset(-Constants.FeedModule.Collection.containerPadding)
            make.top.equalToSuperview().offset(Constants.FeedModule.Collection.containerPadding)
        }
        
        return view
    }()
    
    fileprivate lazy var lockView: UIView = { [unowned self] in
        let lock = UIImageView(image: UIImage(asset: .iconPrivate))
        
        return UIView()
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _ = summaryView
    }
}

