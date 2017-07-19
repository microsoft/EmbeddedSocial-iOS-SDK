//
//  SideMenuSideMenuInteractorInput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import Foundation

protocol SideMenuInteractorInput {
    func socialMenuItems() -> [SideMenuItemModel]
    func clientMenuItems() -> [SideMenuItemModel]
    func targetForSocialMenuItem(with index:Int) -> UIViewController
    func targetForClientMenuItem(with index:Int) -> UIViewController
}
