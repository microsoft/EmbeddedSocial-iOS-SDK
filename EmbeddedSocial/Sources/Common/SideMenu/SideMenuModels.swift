//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct SideMenuSectionModel {
    var title: String
    var collapsible: Bool
    var isCollapsed: Bool
    var items: [SideMenuItemModel]
    
    mutating func setCollapsed(collapsed: Bool) {
        if collapsible {
            isCollapsed = collapsed
        }
    }
}

struct SideMenuItemModel {
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

struct SideMenuHeaderModel {
    var title: String
    var image: Photo
    var isSelected: Bool
}
