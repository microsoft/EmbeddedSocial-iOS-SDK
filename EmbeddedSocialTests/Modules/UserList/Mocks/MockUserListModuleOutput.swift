//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUserListModuleOutput: UserListModuleOutput {
    private(set) var didSelectListItemCount = 0
    private(set) var didUpdateListCount = 0
    private(set) var didFailToLoadListCount = 0
    private(set) var didFailToPerformSocialRequestCount = 0

    func didSelectListItem(listView: UIView, at indexPath: IndexPath) {
        didSelectListItemCount += 1
    }
    
    func didUpdateList(listView: UIView) {
        didUpdateListCount += 1
    }
    
    func didFailToLoadList(listView: UIView, error: Error) {
        didFailToLoadListCount += 1
    }
    
    func didFailToPerformSocialRequest(listView: UIView, error: Error) {
        didFailToPerformSocialRequestCount += 1
    }
}
