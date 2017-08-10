//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserListViewOutput: class {
    func onItemAction(item: UserListItem)
    
    func onReachingEndOfPage()
    
    func onItemSelected(at indexPath: IndexPath)
}
