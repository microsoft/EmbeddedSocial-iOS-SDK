//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class SideMenuViewInputMock: SideMenuViewInput {
    
    //MARK: - setupInitialState
    
    var setupInitialStateCalled = false
    
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
    //MARK: - reload
    
    var reloadCalled = false
    
    func reload() {
        reloadCalled = true
    }
    
    //MARK: - reload
    
    var reloadSectionCalled = false
    var reloadSectionReceivedSection: Int?
    
    func reload(section: Int) {
        reloadSectionCalled = true
        reloadSectionReceivedSection = section
    }
    
    //MARK: - reload
    
    var reloadItemCalled = false
    var reloadItemReceivedItem: IndexPath?
    
    func reload(item: IndexPath) {
        reloadItemCalled = true
        reloadItemReceivedItem = item
    }
    
    //MARK: - showTabBar
    
    var showTabBarVisibleCalled = false
    var showTabBarVisibleReceivedVisible: Bool?
    
    func showTabBar(visible: Bool) {
        showTabBarVisibleCalled = true
        showTabBarVisibleReceivedVisible = visible
    }
    
    //MARK: - selectBar
    
    var selectBarWithCalled = false
    var selectBarWithReceivedIndex: Int?
    
    func selectBar(with index: Int) {
        selectBarWithCalled = true
        selectBarWithReceivedIndex = index
    }
    
    //MARK: - showAccountInfo
    
    var showAccountInfoVisibleCalled = false
    var showAccountInfoVisibleReceivedVisible: Bool?
    
    func showAccountInfo(visible: Bool) {
        showAccountInfoVisibleCalled = true
        showAccountInfoVisibleReceivedVisible = visible
    }
    
}
