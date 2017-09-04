//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockSearchView: SearchViewInput {
    
    //MARK: - setupInitialState
    
    var setupInitialStateCalled = false
    var setupInitialStateReceivedTab: SearchTabInfo?
    
    func setupInitialState(_ tab: SearchTabInfo) {
        setupInitialStateCalled = true
        setupInitialStateReceivedTab = tab
    }
    
    //MARK: - switchTabs
    
    var switchTabsToFromCalled = false
    var switchTabsToFromReceivedArguments: (tab: SearchTabInfo, previousTab: SearchTabInfo)?
    
    func switchTabs(to tab: SearchTabInfo, from previousTab: SearchTabInfo) {
        switchTabsToFromCalled = true
        switchTabsToFromReceivedArguments = (tab: tab, previousTab: previousTab)
    }
    
    //MARK: - showError
    
    var showErrorCalled = false
    var showErrorReceivedError: Error?
    
    func showError(_ error: Error) {
        showErrorCalled = true
        showErrorReceivedError = error
    }
    
    //MARK: - setLayoutAsset
    
    var setLayoutAssetCalled = false
    var setLayoutAssetReceivedAsset: Asset?
    
    func setLayoutAsset(_ asset: Asset) {
        setLayoutAssetCalled = true
        setLayoutAssetReceivedAsset = asset
    }
    
}
