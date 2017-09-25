//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol FollowingNoDataViewDelegate: class {
    
    func didSelectSearchPeople()
    
    func didSelectSuggestedUsers()
}

class FollowingNoDataView: UIView {
    
    weak var delegate: FollowingNoDataViewDelegate?
    
    @IBOutlet fileprivate weak var noDataLabel: UILabel! {
        didSet {
            noDataLabel.text = L10n.Following.noDataText
            noDataLabel.textColor = Palette.darkGrey
            noDataLabel.font = Fonts.medium
        }
    }
    
    @IBOutlet fileprivate weak var searchPeopleButton: UIButton! {
        didSet {
            searchPeopleButton.setTitle(L10n.Following.searchPeople, for: .normal)
        }
    }
    
    @IBOutlet fileprivate weak var suggestedUsersButton: UIButton! {
        didSet {
            suggestedUsersButton.setTitle(L10n.Following.suggestedUsers, for: .normal)
        }
    }
    
    @IBOutlet fileprivate weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func onSearchPeople(_ sender: UIButton) {
        delegate?.didSelectSearchPeople()
    }
    
    @IBAction private func onSuggestedUsers(_ sender: UIButton) {
        delegate?.didSelectSuggestedUsers()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return containerView.point(inside: convert(point, to: containerView), with: event)
    }
}
