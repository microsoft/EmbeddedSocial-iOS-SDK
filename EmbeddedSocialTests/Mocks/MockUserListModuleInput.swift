//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserListModuleInput: UserListModuleInput {
    var listView = UIView()
    
    var isListEmpty = false
    
    //MARK: - setupInitialState
    
    var setupInitialStateCalled = false
    
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
    //MARK: - reload
    
    var reloadWithCalled = false
    var reloadWithReceivedApi: UsersListAPI?
    
    func reload(with api: UsersListAPI) {
        reloadWithCalled = true
        reloadWithReceivedApi = api
    }
    
    //MARK: - setListHeaderView
    
    var setListHeaderViewCalled = false
    var setListHeaderViewReceivedView: UIView?
    
    func setListHeaderView(_ view: UIView?) {
        setListHeaderViewCalled = true
        setListHeaderViewReceivedView = view
    }
    
    //MARK: - removeUser
    
    var removeUserCalled = false
    var removeUserReceivedUser: User?
    
    func removeUser(_ user: User) {
        removeUserCalled = true
        removeUserReceivedUser = user
    }
    
    //MARK: - clearList
    
    var clearListCalled = false
    
    func clearList() {
        clearListCalled = true
    }
}
