//
//  ActivityButtonCell.swift
//  EmbeddedSocial
//
//  Created by Mac User on 02.10.17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class ActivityButtonCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func cellSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 100)
    }
}
