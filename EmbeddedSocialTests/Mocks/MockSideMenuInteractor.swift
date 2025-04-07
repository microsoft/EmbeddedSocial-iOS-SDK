//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class SideMenuInteractorInputMock: SideMenuInteractorInput {
    
    //MARK: - socialMenuItems
    
    var socialMenuItemsCalled = false
    var socialMenuItemsReturnValue: [SideMenuItemModelProtocol]!
    
    func socialMenuItems() -> [SideMenuItemModelProtocol] {
        socialMenuItemsCalled = true
        return socialMenuItemsReturnValue
    }
    
    //MARK: - clientMenuItems
    
    var clientMenuItemsCalled = false
    var clientMenuItemsReturnValue: [SideMenuItemModelProtocol]!
    
    func clientMenuItems() -> [SideMenuItemModelProtocol] {
        clientMenuItemsCalled = true
        return clientMenuItemsReturnValue
    }
    
    //MARK: - targetForSocialMenuItem
    
    var targetForSocialMenuItemWithCalled = false
    var targetForSocialMenuItemWithReceivedIndex: Int?
    var targetForSocialMenuItemWithReturnValue: UIViewController!
    
    func targetForSocialMenuItem(with index:Int) -> UIViewController {
        targetForSocialMenuItemWithCalled = true
        targetForSocialMenuItemWithReceivedIndex = index
        return targetForSocialMenuItemWithReturnValue
    }
    
    //MARK: - targetForClientMenuItem
    
    var targetForClientMenuItemWithCalled = false
    var targetForClientMenuItemWithReceivedIndex: Int?
    var targetForClientMenuItemWithReturnValue: UIViewController!
    
    func targetForClientMenuItem(with index:Int) -> UIViewController {
        targetForClientMenuItemWithCalled = true
        targetForClientMenuItemWithReceivedIndex = index
        return targetForClientMenuItemWithReturnValue
    }
    
    //MARK: - getSocialItemIndex
    
    var getSocialItemIndexForCalled = false
    var getSocialItemIndexForReceivedItem: SocialItem?
    var getSocialItemIndexForReturnValue: Int?
    
    func getSocialItemIndex(for item: SocialItem) -> Int? {
        getSocialItemIndexForCalled = true
        getSocialItemIndexForReceivedItem = item
        return getSocialItemIndexForReturnValue
    }
    
    //MARK: - getNotificationsCount
    
    var getNotificationsCountOnUpdatedCalled = false
    var getNotificationsCountOnUpdatedReceivedOnUpdated: (() -> Void)?
    
    func getNotificationsCount(onUpdated: @escaping () -> Void) {
        getNotificationsCountOnUpdatedCalled = true
        getNotificationsCountOnUpdatedReceivedOnUpdated = onUpdated
    }
    
}
