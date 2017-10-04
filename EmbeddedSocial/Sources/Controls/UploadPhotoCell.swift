//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

final class UploadPhotoCell: UITableViewCell {
    
    fileprivate let photoImageView = UIImageView()
    fileprivate let uploadLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(uploadLabel)
        setupLayout()
        setupSubviews()
    }
    
    private func setupLayout() {
        photoImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(Constants.CreateAccount.contentPadding)
            make.centerY.equalTo(contentView)
            make.height.equalTo(photoImageView.snp.width)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.65)
        }
        
        uploadLabel.snp.makeConstraints { make in
            make.left.equalTo(photoImageView.snp.right).offset(16.0)
            make.centerY.equalTo(contentView)
            make.width.lessThanOrEqualTo(contentView).offset(Constants.CreateAccount.contentPadding)
        }
    }
    
    private func setupSubviews() {
        uploadLabel.font = AppFonts.regular
        uploadLabel.textColor = Palette.darkGrey
        uploadLabel.text = L10n.UploadPhotoCell.uploadPhoto
        
        photoImageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        photoImageView.makeCircular()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UploadPhotoCell {
    func configure(photo: Photo?) {
        photoImageView.setPhotoWithCaching(photo, placeholder: UIImage(asset: .userPhotoPlaceholder))
    }
}

extension UploadPhotoCell: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        uploadLabel.textColor = palette.textPrimary
    }
}
