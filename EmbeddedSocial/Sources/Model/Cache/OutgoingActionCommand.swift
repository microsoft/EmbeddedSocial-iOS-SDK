//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class OutgoingActionOperation: AsyncOperation {
    private let action: OutgoingAction
    
    init(action: OutgoingAction) {
        self.action = action
        super.init()
    }
}

class SocialActionOperation: OutgoingActionOperation {
    let socialService: SocialServiceType
    
    init(socialService: SocialServiceType, action: OutgoingAction) {
        self.socialService = socialService
        super.init(action: action)
    }
}

final class FollowOperation: SocialActionOperation {
//    init(userID: String, )
    
    override func main() {
        socialService.follow(userID: <#T##String#>, completion: <#T##(Result<Void>) -> Void#>)
    }
}
