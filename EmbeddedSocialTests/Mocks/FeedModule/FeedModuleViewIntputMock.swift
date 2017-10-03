//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class FeedModuleViewInputMock: FeedModuleViewInput {
    
    //MARK: - needShowNoContent
    var needShowNoContentStateCalled = false
    var needShowNoContentStateReceivedState: Bool?
    
    func needShowNoContent(state: Bool) {
        needShowNoContentStateCalled = true
        needShowNoContentStateReceivedState = state
    }
    
    //MARK: - reloadVisible
    var reloadVisibleCalled = false
    
    func reloadVisible() {
        reloadVisibleCalled = true
    }
    
    //MARK: - insertNewItems
    
    var insertNewItemsWithCalled = false
    var insertNewItemsWithReceivedPaths: [IndexPath]?
    
    func insertNewItems(with paths: [IndexPath]) {
        insertNewItemsWithCalled = true
        insertNewItemsWithReceivedPaths = paths
    }
    
    //MARK: - removeItems
    
    var removeItemsWithCalled = false
    var removeItemsWithReceivedPaths: [IndexPath]?
    
    func removeItems(with paths: [IndexPath]) {
        removeItemsWithCalled = true
        removeItemsWithReceivedPaths = paths
    }
    
    //MARK: - setupInitialState
    var paddingEnabled: Bool = false
    
    var setupInitialState_Called = false
    
    func setupInitialState() {
        setupInitialState_Called = true
    }
    
    var resetFocus_Called = false
    func resetFocus() {
        resetFocus_Called = true
    }
    
    var itemsLimit: Int {
        return Constants.Feed.pageSize
    }
    
    //MARK: - setLayout
    
    var setLayoutCalled = false
    var setLayoutReceivedType: FeedModuleLayoutType?
    
    func setLayout(type: FeedModuleLayoutType) {
        setLayoutCalled = true
        setLayoutReceivedType = type
    }
    
    //MARK: - reload
    
    var reload_Called = false
    var reload_Called_Times: Int?
    
    func reload() {
        reload_Called = true
        reload_Called_Times = (reload_Called_Times == nil) ? 1 : reload_Called_Times! + 1
    }
    
    //MARK: - reload
    
    var reload_with_Called = false
    var reload_with_ReceivedIndex: Int?
    
    func reload(with index: Int) {
        reload_with_Called = true
        reload_with_ReceivedIndex = index
    }
    
    //MARK: - removeItem
    
    var removeItem_index_Called = false
    var removeItem_index_ReceivedIndex: Int?
    
    func removeItem(index: Int) {
        removeItem_index_Called = true
        removeItem_index_ReceivedIndex = index
    }
    
    //MARK: - setRefreshing
    
    var setRefreshing_state_Called = false
    var setRefreshing_state_ReceivedState: Bool?
    
    func setRefreshing(state: Bool) {
        setRefreshing_state_Called = true
        setRefreshing_state_ReceivedState = state
    }
    
    //MARK: - setRefreshingWithBlocking
    
    var setRefreshingWithBlocking_state_Called = false
    var setRefreshingWithBlocking_state_ReceivedState: Bool?
    
    func setRefreshingWithBlocking(state: Bool) {
        setRefreshingWithBlocking_state_Called = true
        setRefreshingWithBlocking_state_ReceivedState = state
    }
    
    //MARK: - showError
    
    var showError_error_Called = false
    var showError_error_ReceivedError: Error?
    
    func showError(error: Error) {
        showError_error_Called = true
        showError_error_ReceivedError = error
    }
    
    //MARK: - registerHeader<T: UICollectionReusableView>
    
    var registerHeader_withType_configurator_Called = false
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type, configurator: @escaping (T) -> Void) {
        registerHeader_withType_configurator_Called = true
    }
    
    //MARK: - refreshLayout
    
    var refreshLayout_Called = false
    
    func refreshLayout() {
        refreshLayout_Called = true
    }
    
    //MARK: - getViewHeight
    
    var getViewHeight_Called = false
    var getViewHeight_ReturnValue: CGFloat!
    
    func getViewHeight() -> CGFloat {
        getViewHeight_Called = true
        return getViewHeight_ReturnValue
    }

    //MARK: - setScrolling
    
    var setScrolling_Called = false
    func setScrolling(enable: Bool) {
        setScrolling_Called = true
    }
    
}
