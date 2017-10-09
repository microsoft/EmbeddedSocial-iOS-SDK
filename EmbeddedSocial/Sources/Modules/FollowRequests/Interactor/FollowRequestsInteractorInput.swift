//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol FollowRequestsInteractorInput: class {
    var isLoadingList: Bool { get }
    
    var listHasMoreItems: Bool { get }
    
    func getNextListPage(completion: @escaping (Result<[User]>) -> Void)
    
    func reloadList(completion: @escaping (Result<[User]>) -> Void)
    
    func acceptPendingRequest(to user: User, completion: @escaping (Result<Void>) -> Void)
    
    func rejectPendingRequest(to user: User, completion: @escaping (Result<Void>) -> Void)
}
