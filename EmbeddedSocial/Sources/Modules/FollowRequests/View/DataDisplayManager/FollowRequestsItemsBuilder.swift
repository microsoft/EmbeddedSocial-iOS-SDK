//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct FollowRequestItemsBuilder {
    typealias Section = FollowRequestsDataDisplayManager.Section
    
    func makeSections(users: [User]) -> [Section] {
        let items = users.map(FollowRequestItem.init)
        return [Section(model: (), items: items)]
    }
}
