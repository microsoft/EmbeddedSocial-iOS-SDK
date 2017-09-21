//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserCommandOperation: OutgoingCommandOperation {
    let command: UserCommand
    let socialService: SocialServiceType
    
    init(command: UserCommand, socialService: SocialServiceType) {
        self.command = command
        self.socialService = socialService
        super.init()
    }
}
