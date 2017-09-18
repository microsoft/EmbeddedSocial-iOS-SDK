//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension Activity.ActionItem {
    
    init?(with model: ActivityView) {
    
        guard let rawTypeValue = model.activityType?.rawValue else { return nil }
        guard let type = ActivityType(rawValue: rawTypeValue) else { return nil }
        
        guard let actorUsers = model.actorUsers,
            let actedOnUserName = model.actedOnUser?.firstName
            else { return nil }
        
        self.type = type
        
        for user in actorUsers {
            if let firstName = user.firstName, let lastName = user.lastName {
                self.actorNameList.append((firstName, lastName))
            }
        }
        
        self.unread = model.unread ?? true
        self.actedOnName = actedOnUserName
    }
}


