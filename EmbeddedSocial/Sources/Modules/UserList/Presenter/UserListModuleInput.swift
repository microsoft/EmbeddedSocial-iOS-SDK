//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol UserListModuleInput: class {
    var listView: UIView { get }

    func setupInitialState()
    
    func reload(with api: UsersListAPI)
    
    func setListHeaderView(_ view: UIView?)
    
    func removeUser(_ user: User)
}
