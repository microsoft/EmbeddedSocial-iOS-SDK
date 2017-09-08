//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserListViewInput: class {
    func setupInitialState()
    
    func setUsers(_ users: [User])
    
    func updateListItem(with user: User)
    
    func setIsLoading(_ isLoading: Bool, item: UserListItem)
    
    func setIsLoading(_ isLoading: Bool)
    
    func setListHeaderView(_ view: UIView?)
    
    func removeUser(_ user: User)
}
