//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

private let headerAspectRatio: CGFloat = 2.25
private let containerInset: CGFloat = 4.0
private let filterHeight: CGFloat = 44.0

class UserProfileViewController: UIViewController {
    
    var output: UserProfileViewOutput!
    
    @IBOutlet fileprivate weak var containerTableView: UITableView! {
        didSet {
            containerTableView.dataSource = self
            containerTableView.delegate = self
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
        
        let width = UIScreen.main.bounds.width - containerInset * 2
        summaryView.frame = CGRect(x: 0.0, y: 0.0, width: width, height: width / headerAspectRatio)
        
        return summaryView
    }()
    
    fileprivate lazy var filterView: UserProfileFilterView = { [unowned self] in
        let filterView = UserProfileFilterView.fromNib()
        filterView.backgroundColor = .yellow
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
        containerTableView.tableHeaderView = summaryView
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isHidden = !isLoading
        loadingIndicatorView.isLoading = isLoading
        containerTableView.isHidden = isLoading
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

extension UserProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CellID")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

extension UserProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return filterView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return filterHeight
    }
}
