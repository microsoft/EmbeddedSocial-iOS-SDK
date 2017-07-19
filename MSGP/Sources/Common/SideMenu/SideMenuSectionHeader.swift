
//
//  MenuSectionHeader.swift
//  MSGP
//
//  Created by Igor Popov on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import SnapKit

protocol SideMenuSectionHeaderDelegate: class {
    
    func didToggle(section: SideMenuSectionHeader, index: Int)
}

class SideMenuSectionHeader: UITableViewHeaderFooterView {
    
    var title: UILabel = UILabel()
    weak var delegate: SideMenuSectionHeaderDelegate?
    var index: Int = 0
    var model: SideMenuSectionModel? {
        didSet {
            guard let model = model else {
                return
            }
            
            title.text = model.title
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initialSetup()
    }

    func initialSetup() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(recognizer)
        

        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
    }
    
    @objc private func handleTap() {
        delegate?.didToggle(section: self, index: index)
    }
}
