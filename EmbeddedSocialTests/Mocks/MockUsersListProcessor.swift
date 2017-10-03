//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUsersListProcessor: UsersListProcessorType {
    var isLoadingList = false
    
    var listHasMoreItems = false
    
    var delegate: UsersListProcessorDelegate?
    
    //MARK: - getNextListPage
    
    var getNextListPageCompletionCalled = false
    var getNextListPageCompletionReturnValue: Result<[User]>!
    
    func getNextListPage(completion: @escaping (Result<[User]>) -> Void) {
        getNextListPageCompletionCalled = true
        completion(getNextListPageCompletionReturnValue)
    }
    
    //MARK: - setAPI
    
    var setAPICalled = false
    var setAPIReceivedApi: UsersListAPI?
    
    func setAPI(_ api: UsersListAPI) {
        setAPICalled = true
        setAPIReceivedApi = api
    }
    
    //MARK: - reloadList
    
    var reloadListCompletionCalled = false
    var reloadListCompletionReturnValue: Result<[User]>!
    
    func reloadList(completion: @escaping (Result<[User]>) -> Void) {
        reloadListCompletionCalled = true
        completion(reloadListCompletionReturnValue)
    }
    
}

