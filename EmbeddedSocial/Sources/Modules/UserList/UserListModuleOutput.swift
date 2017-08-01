//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserListModuleOutput: class {
    func didSelectListItem(listView: UIView, at indexPath: IndexPath)
    
    func didLoadList(listView: UIView)
    
    func didFailToLoadList(listView: UIView, _ error: Error)
}
