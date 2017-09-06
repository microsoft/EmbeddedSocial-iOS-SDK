//
//  LoadMoreCell.swift
//  EmbeddedSocial
//
//  Created by Mac User on 06.09.17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

protocol LoadMoreCellDelegate: class {
    func loadPressed()
}


class LoadMoreCellViewModel {
    var cellHeight: CGFloat = 40
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(viewModel: LoadMoreCellViewModel) {
        loadButton.isHidden = viewModel.shouldHideLoadingLabel
        activityIndicator.isHidden = viewModel.shouldHideActivityIndicator
    }

    @IBAction func loadPressed(_ sender: Any) {
        delegate?.loadPressed()
    }
}
