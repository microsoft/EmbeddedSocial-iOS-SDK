//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserListModuleInput: UserListModuleInput {
    private(set) var setupInitialStateCount = 0
    private(set) var reloadCount = 0
    private(set) var setListHeaderViewCount = 0
    
    private(set) var api: UsersListAPI?
    private(set) var headerView: UIView?
    
    var listView = UIView()

    func setupInitialState() {
        setupInitialStateCount += 1
    }
    
    func reload(with api: UsersListAPI) {
        reloadCount += 1
        self.api = api
    }
    
    func setListHeaderView(_ view: UIView?) {
        setListHeaderViewCount += 1
        self.headerView = view
    }
}
