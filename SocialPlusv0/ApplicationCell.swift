//
//  ApplicationCell.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ApplicationCell: UITableViewCell {
    
    @IBOutlet weak var applicationIcon: UIImageView!
    @IBOutlet weak var applicationNameLabel: UILabel!
    @IBOutlet weak var toggleEnabledAppSwitch: UISwitch!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
