//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SideMenuAccountInfoView: UIControl {
    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountImage: UIImageView!
    
    fileprivate var selectedTextColor: UIColor = Palette.green
    fileprivate var defaultTextColor: UIColor = Palette.white
    
    func configure(with model: SideMenuHeaderModel) {
        accountImage.setPhotoWithCaching(model.image, placeholder: UIImage(asset: AppConfiguration.shared.theme.assets.userPhotoPlaceholder))
        accountName.text = model.title
        isSelected = model.isSelected
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = Palette.darkGrey
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accountImage?.makeCircular()
    }
    
    override var isSelected: Bool {
        didSet {
            accountName?.textColor = isSelected ? selectedTextColor : defaultTextColor
        }
    }
    
}

extension SideMenuAccountInfoView: Themeable {
    func apply(theme: Theme?) {
        
        guard let palette = theme?.palette else {
            return
        }
        
        selectedTextColor = palette.accent
        defaultTextColor = palette.textPrimary
    }
}

