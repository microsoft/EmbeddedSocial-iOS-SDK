//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SideMenuCellView: UITableViewCell {
    
    var picture: UIImageView = {
        let p = UIImageView()
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    var title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = Palette.white
        return l
    }()
    
    func configure(withModel model: SideMenuItemModelProtocol)  {
        picture.image = model.isSelected ? model.imageHighlighted : model.image
        title.text = model.title
        isSelected = model.isSelected
    }
    
    override func prepareForReuse() {
        picture.image = nil
        title.text = nil
        isSelected = false
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        self.selectionStyle = .none
        contentView.backgroundColor = Palette.lightGrey
        
        contentView.addSubview(title)
        contentView.addSubview(picture)
        
        picture.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(picture).offset(40)
        }
    }
    
    override public var isSelected: Bool {
        didSet {
            title.textColor = isSelected ? Constants.Menu.selectedItemColor : Constants.Menu.defaultItemColor
        }
    }
}

class SideMenuCellViewWithNotification: SideMenuCellView {
    
    var notificationLabel = ActivityNotificationLabel()
    
    override func configure(withModel model: SideMenuItemModelProtocol) {
        super.configure(withModel: model)
        
        guard let notificationModel = model as? SideMenuItemModelWithNotification else {
            fatalError("wrong model")
        }
        notificationLabel.setCountText(notificationModel.countText)
    }
    
}
