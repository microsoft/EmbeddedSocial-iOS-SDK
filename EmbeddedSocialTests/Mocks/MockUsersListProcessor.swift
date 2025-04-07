//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUsersListProcessor: AbstractPaginatedListProcessor<User> {
    var _listHasMoreItems = false
    
    override var listHasMoreItems: Bool {
        return _listHasMoreItems
    }
    
    //MARK: - getNextListPage
    
    var getNextListPageCompletionCalled = false
    var getNextListPageCompletionReturnValue: Result<[User]>!
    
    override func getNextListPage(completion: @escaping (Result<[User]>) -> Void) {
        getNextListPageCompletionCalled = true
        completion(getNextListPageCompletionReturnValue)
    }
    
    //MARK: - setAPI
    
    var setAPICalled = false
    var setAPIReceivedApi: ListAPI<User>?
    
    override func setAPI(_ api: ListAPI<User>) {
        setAPICalled = true
        setAPIReceivedApi = api
    }
    
    //MARK: - reloadList
    
    var reloadListCompletionCalled = false
    var reloadListCompletionReturnValue: Result<[User]>!
    
    override func reloadList(completion: @escaping (Result<[User]>) -> Void) {
        reloadListCompletionCalled = true
        completion(reloadListCompletionReturnValue)
    }
    
}

