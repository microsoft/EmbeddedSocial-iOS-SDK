//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct OutgoingActionOperationsBuilder {
    
    static func operation(for action: OutgoingAction) -> OutgoingActionOperation? {
        switch action.type {
        case .follow:
            return FollowOperation(socialService: SocialService(), action: action)
            
        case .unfollow:
            return UnfollowOperation(socialService: SocialService(), action: action)
            
        case .block:
            return BlockOperation(socialService: SocialService(), action: action)
            
        case .unblock:
            return UnblockOperation(socialService: SocialService(), action: action)

        default:
            return nil
        }
    }
}
