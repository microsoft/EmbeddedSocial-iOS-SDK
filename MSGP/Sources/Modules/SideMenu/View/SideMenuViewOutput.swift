//
//  SideMenuSideMenuViewOutput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
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
    func sectionHeader(section index: Int) -> SideMenuHeaderModel?
    
}
