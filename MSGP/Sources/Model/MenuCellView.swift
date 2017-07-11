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
    
    func configure(vm: MenuCellViewModel)  {
        picture!.image = UIImage(named:vm.pictureName)
        title!.text = vm.title
    }
    
}
