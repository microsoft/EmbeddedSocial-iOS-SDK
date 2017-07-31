//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SideMenuInteractorInput {
    func socialMenuItems() -> [SideMenuItemModel]
    func clientMenuItems() -> [SideMenuItemModel]
    func targetForSocialMenuItem(with index:Int) -> UIViewController
    func targetForClientMenuItem(with index:Int) -> UIViewController
}
