//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ReplyCommandOperation: AsyncOperation {
    let command: ReplyCommand
    let likesService: LikesServiceProtocol
    
    init(command: ReplyCommand, likesService: LikesServiceProtocol) {
        self.command = command
        self.likesService = likesService
        super.init()
    }
}
