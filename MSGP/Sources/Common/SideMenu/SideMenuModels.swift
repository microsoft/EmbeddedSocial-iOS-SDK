//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

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
}

struct SideMenuHeaderModel {
    var accountName: String
    var accountPhoto: Photo
}
