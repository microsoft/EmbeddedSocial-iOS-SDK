//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class GroupHeaderTableCell: UITableViewCell {

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    @IBOutlet fileprivate weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var leadingConstraint: NSLayoutConstraint!
    
    fileprivate var titleInsets: UIEdgeInsets = .zero {
        didSet {
            bottomConstraint.constant = titleInsets.bottom
            trailingConstraint.constant = titleInsets.right
            leadingConstraint.constant = titleInsets.left
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel?.text = nil
    }
}

extension GroupHeaderTableCell {
    func configure(title: String?) {
        titleLabel.text = title
    }
}

extension GroupHeaderTableCell {
    struct Style {
        let titleColor: UIColor?
        let titleFont: UIFont
        let backgroundColor: UIColor?
        let titleInsets: UIEdgeInsets
    }
}

extension GroupHeaderTableCell {
    func apply(style: Style) {
        titleLabel?.textColor = style.titleColor
        titleLabel?.font = style.titleFont
        backgroundColor = style.backgroundColor
        titleInsets = style.titleInsets
    }
}

extension GroupHeaderTableCell.Style {
    typealias Style = GroupHeaderTableCell.Style
    
    static var editProfile: Style {
        let insets = UIEdgeInsets(top: 0.0, left: Constants.CreateAccount.contentPadding, bottom: 0.0, right: 0.0)
        return Style(titleColor: SocialPlus.palette.textPrimary,
                     titleFont: AppFonts.regular,
                     backgroundColor: SocialPlus.palette.tableGroupHeaderBackground,
                     titleInsets: insets)
    }
    
    static var search: Style {
        let insets = UIEdgeInsets(top: 0.0, left: Constants.CreateAccount.contentPadding, bottom: 0.0, right: 0.0)
        return Style(titleColor: SocialPlus.palette.textPrimary,
                     titleFont: AppFonts.regular,
                     backgroundColor: SocialPlus.palette.tableGroupHeaderBackground,
                     titleInsets: insets)
    }
}
