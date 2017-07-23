//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SideMenuAccountInfoView: UIControl {
    
    var accountImage = UIImageView()
    var accountName = UILabel()
    let accountImageOffset = 20.0
    let accountNameeOffset = 15.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        // visual
        clipsToBounds = true
        accountImage.contentMode = .scaleAspectFit
        accountName.textColor = UIColor.white
        
        addSubview(accountImage)
        accountImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(accountImageOffset).priority(750)
            make.top.greaterThanOrEqualToSuperview().offset(accountImageOffset).priority(750)
            make.bottom.lessThanOrEqualToSuperview().offset(-accountImageOffset).priority(750)
            make.width.equalTo(accountImage.snp.height).priority(750)
        }
        
        addSubview(accountName)
        accountName.snp.makeConstraints { (make) in
            make.centerY.equalTo(accountImage)
            make.left.equalTo(accountImage.snp.right).offset(accountNameeOffset)
        }
    }
    
    func configure(with model: SideMenuHeaderModel) {
        accountImage.setPhotoWithCaching(model.image, placeholder: nil)
        accountName.text = model.title
    }
}
