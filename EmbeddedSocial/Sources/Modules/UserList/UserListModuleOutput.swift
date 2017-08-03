//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserListModuleOutput: class {
    func didSelectListItem(listView: UIView, at indexPath: IndexPath)
    
    func didUpdateList(listView: UIView)
    
    func didFailToLoadList(listView: UIView, error: Error)
    
    func didTriggerUserAction(_ user: User)
    
    func didFailToPerformSocialRequest(listView: UIView, error: Error)
}

//MARK: - Optional methods

extension UserListModuleOutput {
    func didFailToPerformSocialRequest(listView: UIView, error: Error) { }
    
    func didTriggerUserAction(_ user: User) { }
    
    func didSelectListItem(listView: UIView, at indexPath: IndexPath) { }
    
    func didUpdateList(listView: UIView) { }
    
    func didFailToLoadList(listView: UIView, error: Error) { }
}
