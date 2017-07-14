//
//  MenuCellView.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import UIKit

class MenuCellView: UITableViewCell {
    
    @IBOutlet weak var picture: UIImageView?
    @IBOutlet weak var title: UILabel?
    
    func configure(withModel model: MenuItemModel)  {
        
        picture!.image = UIImage(named:model.pictureName,
                                 in:Bundle(for: type(of: self)),
                                 compatibleWith:nil)
        title!.text = model.title
    }
    
}
