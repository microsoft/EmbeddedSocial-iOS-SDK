//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockFollowRequestsInteractor: FollowRequestsInteractorInput {
    var isLoadingList = false
    
    var listHasMoreItems = false
    
    //MARK: - getNextListPage
    
    var getNextListPageCompletionCalled = false
    var getNextListPageCompletionReturnValue: Result<[User]>!
    
    func getNextListPage(completion: @escaping (Result<[User]>) -> Void) {
        getNextListPageCompletionCalled = true
        completion(getNextListPageCompletionReturnValue)
    }
    
    //MARK: - reloadList
    
    var reloadListCompletionCalled = false
    var reloadListCompletionReturnValue: Result<[User]>!
    
    func reloadList(completion: @escaping (Result<[User]>) -> Void) {
        reloadListCompletionCalled = true
        completion(reloadListCompletionReturnValue)
    }
    
    //MARK: - acceptPendingRequest
    
    var acceptPendingRequestToCompletionCalled = false
    var acceptPendingRequestToCompletionReceivedUser: User?
    var acceptPendingRequestReturnValue: Result<Void>!
    
    func acceptPendingRequest(to user: User, completion: @escaping (Result<Void>) -> Void) {
        acceptPendingRequestToCompletionCalled = true
        acceptPendingRequestToCompletionReceivedUser = user
        completion(acceptPendingRequestReturnValue)
    }
    
    //MARK: - rejectPendingRequest
    
    var rejectPendingRequestToCompletionCalled = false
    var rejectPendingRequestToCompletionReceivedUser: User?
    var rejectPendingRequestToCompletionReturnValue: Result<Void>!
    
    func rejectPendingRequest(to user: User, completion: @escaping (Result<Void>) -> Void) {
        rejectPendingRequestToCompletionCalled = true
        rejectPendingRequestToCompletionReceivedUser = user
        completion(rejectPendingRequestToCompletionReturnValue)
    }
    
}

