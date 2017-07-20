//
//  File.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
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
