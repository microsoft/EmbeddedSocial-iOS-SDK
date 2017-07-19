//
//  MenuCellView.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import UIKit

class SideMenuCellView: UITableViewCell {
    
    @IBOutlet weak var picture: UIImageView?
    @IBOutlet weak var title: UILabel?
    
    func configure(withModel model: SideMenuItemModel)  {
        
        picture!.image = model.image
        title!.text = model.title
        
    }
    
}
