//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
