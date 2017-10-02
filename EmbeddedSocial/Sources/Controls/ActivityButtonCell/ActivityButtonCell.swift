//
//  ActivityButtonCell.swift
//  EmbeddedSocial
//
//  Created by Mac User on 02.10.17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

protocol ActivityButtonCellDelegate: class {
    func openPressed()
}

class ActivityButtonCell: UICollectionViewCell {

    @IBOutlet weak var openButton: UIButton!
    
    weak var delegate: ActivityButtonCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func openPressed(_ sender: Any) {
        delegate?.openPressed()
    }
    
    static func cellSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 100)
    }
}
