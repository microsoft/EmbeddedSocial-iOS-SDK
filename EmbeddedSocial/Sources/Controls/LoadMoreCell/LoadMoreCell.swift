//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol LoadMoreCellDelegate: class {
    func loadPressed()
}


class LoadMoreCellViewModel {
    var cellHeight: CGFloat = LoadMoreCell.cellHeight
    var shouldHideActivityIndicator = true
    var shouldHideLoadingLabel = false
    
    func startLoading() {
        shouldHideActivityIndicator = false
        shouldHideLoadingLabel = true
    }
    
    func stopLoading() {
        shouldHideActivityIndicator = true
        shouldHideLoadingLabel = false
    }
}

class LoadMoreCell: UICollectionViewCell {

    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate: LoadMoreCellDelegate?
    
    static let cellHeight: CGFloat = 40
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(viewModel: LoadMoreCellViewModel) {
        loadButton.isHidden = viewModel.shouldHideLoadingLabel
        activityIndicator.isHidden = viewModel.shouldHideActivityIndicator
        activityIndicator.startAnimating()
    }

    @IBAction func loadPressed(_ sender: Any) {
        delegate?.loadPressed()
    }
    
}

extension LoadMoreCell {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        backgroundColor = palette.contentBackground
        activityIndicator.color = palette.loadingIndicator
        loadButton.backgroundColor = palette.contentBackground
        loadButton.setTitleColor(palette.topicSecondaryText, for: .normal)
        loadButton.titleLabel?.font = AppFonts.regular
    }
}
