//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol UserListViewInput: class {
    func setupInitialState()
    
    func setUsers(_ users: [User])
    
    func updateListItem(with user: User)
    
    func setIsLoading(_ isLoading: Bool, item: UserListItem)
    
    func setIsLoading(_ isLoading: Bool)
    
    func setListHeaderView(_ view: UIView?)
    
    func removeUser(_ user: User)
    
    func endPullToRefreshAnimation()
    
    func setNoDataText(_ text: NSAttributedString?)
    
    func setNoDataView(_ view: UIView?)
    
    func setIsEmpty(_ isEmpty: Bool)
    
    var anyItemsShown: Bool { get }
}
