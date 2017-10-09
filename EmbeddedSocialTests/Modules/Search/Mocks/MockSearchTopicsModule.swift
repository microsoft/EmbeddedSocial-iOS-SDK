//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockSearchTopicsModule: SearchTopicsModuleInput {
    var layoutAsset: Asset = .iconAccept
    
    //MARK: - setupInitialState
    
    var setupInitialStateCalled = false
    
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
    //MARK: - searchResultsHandler
    
    var searchResultsHandlerCalled = false
    var searchResultsHandlerReturnValue: SearchResultsUpdating!
    
    func searchResultsHandler() -> SearchResultsUpdating {
        searchResultsHandlerCalled = true
        return searchResultsHandlerReturnValue
    }
    
    //MARK: - backgroundView
    
    var backgroundViewCalled = false
    var backgroundViewReturnValue: UIView?!
    
    func backgroundView() -> UIView? {
        backgroundViewCalled = true
        return backgroundViewReturnValue
    }
    
    //MARK: - searchResultsController
    
    var searchResultsControllerCalled = false
    var searchResultsControllerReturnValue: UIViewController!
    
    func searchResultsController() -> UIViewController {
        searchResultsControllerCalled = true
        return searchResultsControllerReturnValue
    }
    
    //MARK: - flipLayout
    
    var flipLayoutCalled = false
    
    func flipLayout() {
        flipLayoutCalled = true
    }
    
}
