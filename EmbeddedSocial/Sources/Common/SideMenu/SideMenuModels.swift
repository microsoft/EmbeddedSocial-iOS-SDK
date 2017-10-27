//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct SideMenuSectionModel {
    var title: String
    var collapsible: Bool
    var isCollapsed: Bool
    var items: [SideMenuItemModelProtocol]
    
    mutating func setCollapsed(collapsed: Bool) {
        if collapsible {
            isCollapsed = collapsed
        }
    }
}

protocol SideMenuItemModelProtocol {
    var title: String { get set }
    var image: UIImage { get set }
    var imageHighlighted: UIImage { get set }
    var isSelected: Bool { get set }
}

class SideMenuItemModel: SideMenuItemModelProtocol {
    var title: String
    var image: UIImage
    var imageHighlighted: UIImage
    var isSelected: Bool
    
    init(title: String, image: UIImage, imageHighlighted: UIImage, isSelected: Bool = false) {
        self.title = title
        self.image = image
        self.imageHighlighted = imageHighlighted
        self.isSelected = isSelected
    }
}

class SideMenuItemModelWithNotification: SideMenuItemModel {
    var countText: String?
    
    init(title: String, image: UIImage, imageHighlighted: UIImage, isSelected: Bool = false, countText: String? = nil) {
        self.countText = countText
        super.init(title: title, image: image, imageHighlighted: imageHighlighted, isSelected: isSelected)
    }
    
}


struct SideMenuHeaderModel {
    var title: String
    var image: Photo
    var isSelected: Bool
}
