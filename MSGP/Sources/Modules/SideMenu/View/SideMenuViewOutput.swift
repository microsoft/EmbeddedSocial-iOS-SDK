//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol SideMenuViewOutput {

    /**
        @author igor.popov
        Notify presenter that view is ready
    */

    func viewIsReady()
    func didSwitch(to tab: Int)
    func didSelectItem(with path: IndexPath)
    func didToggleSection(with index: Int)
    
    func itemsCount(in section: Int) -> Int
    func sectionsCount() -> Int
    func section(with index: Int) -> SideMenuSectionModel
    func item(at index: IndexPath) -> SideMenuItemModel
    func headerTitle(for section: Int) -> String
    func accountInfo() -> SideMenuHeaderModel?
}
