//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class MockSearchInteractor: SearchInteractorInput {
    
    //MARK: - makePeopleTab
    
    var makePeopleTabWithCalled = false
    var makePeopleTabWithReceivedSearchPeopleModule: SearchPeopleModuleInput?
    var makePeopleTabWithReturnValue: SearchTabInfo!
    
    func makePeopleTab(with searchPeopleModule: SearchPeopleModuleInput) -> SearchTabInfo {
        makePeopleTabWithCalled = true
        makePeopleTabWithReceivedSearchPeopleModule = searchPeopleModule
        return makePeopleTabWithReturnValue
    }
    
    //MARK: - makeTopicsTab
    
    var makeTopicsTabWithCalled = false
    var makeTopicsTabWithReceivedSearchTopicsModule: SearchTopicsModuleInput?
    var makeTopicsTabWithReturnValue: SearchTabInfo!
    
    func makeTopicsTab(with searchTopicsModule: SearchTopicsModuleInput) -> SearchTabInfo {
        makeTopicsTabWithCalled = true
        makeTopicsTabWithReceivedSearchTopicsModule = searchTopicsModule
        return makeTopicsTabWithReturnValue
    }
    
}

