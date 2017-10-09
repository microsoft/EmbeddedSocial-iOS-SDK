//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUserListModuleOutput: UserListModuleOutput {
    //MARK: - didFailToLoadList
    
    var didFailToLoadListListViewErrorCalled = false
    var didFailToLoadListListViewErrorReceivedArguments: (listView: UIView, error: Error)?
    
    func didFailToLoadList(listView: UIView, error: Error) {
        didFailToLoadListListViewErrorCalled = true
        didFailToLoadListListViewErrorReceivedArguments = (listView: listView, error: error)
    }
    
    //MARK: - didFailToPerformSocialRequest
    
    var didFailToPerformSocialRequestListViewErrorCalled = false
    var didFailToPerformSocialRequestListViewErrorReceivedArguments: (listView: UIView, error: Error)?
    
    func didFailToPerformSocialRequest(listView: UIView, error: Error) {
        didFailToPerformSocialRequestListViewErrorCalled = true
        didFailToPerformSocialRequestListViewErrorReceivedArguments = (listView: listView, error: error)
    }
    
    //MARK: - didUpdateFollowStatus
    
    var didUpdateFollowStatusForCalled = false
    var didUpdateFollowStatusForReceivedUser: User?
    
    func didUpdateFollowStatus(for user: User) {
        didUpdateFollowStatusForCalled = true
        didUpdateFollowStatusForReceivedUser = user
    }
}
