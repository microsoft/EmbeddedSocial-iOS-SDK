//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserListModuleOutput: class {
    func didFailToLoadList(listView: UIView, error: Error)
    
    func didFailToPerformSocialRequest(listView: UIView, error: Error)
    
    func didUpdateFollowStatus(for user: User)
    
    func didUpdateList(_ listView: UIView, with users: [User])
}

//MARK: - Optional methods

extension UserListModuleOutput {
    func didFailToPerformSocialRequest(listView: UIView, error: Error) { }
    
    func didFailToLoadList(listView: UIView, error: Error) { }
    
    func didUpdateFollowStatus(for user: User) { }
    
    func didUpdateList(_ listView: UIView, with users: [User]) { }
}
