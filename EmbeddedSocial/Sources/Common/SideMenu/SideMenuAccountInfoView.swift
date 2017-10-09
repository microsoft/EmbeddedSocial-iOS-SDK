//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SideMenuAccountInfoView: UIControl {
    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountImage: UIImageView!
    
    func configure(with model: SideMenuHeaderModel) {
        accountImage.setPhotoWithCaching(model.image, placeholder: UIImage(asset: Asset.userPhotoPlaceholder))
        accountName.text = model.title
        isSelected = model.isSelected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accountImage?.makeCircular()
    }
    
    override var isSelected: Bool {
        didSet {
            accountName?.textColor = isSelected ? Constants.Menu.selectedItemColor : Constants.Menu.defaultItemColor
        }
    }
    
}
