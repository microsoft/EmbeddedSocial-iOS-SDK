//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserListViewInput: class {
    func setupInitialState()
    
    func setUsers(_ users: [User])
    
    func updateListItem(with user: User, at indexPath: IndexPath)
    
    func setIsLoading(_ isLoading: Bool, itemAt indexPath: IndexPath)
    
    func setIsLoading(_ isLoading: Bool)
    
    func setListHeaderView(_ view: UIView?)
    
    func removeListItem(at indexPath: IndexPath)
}
