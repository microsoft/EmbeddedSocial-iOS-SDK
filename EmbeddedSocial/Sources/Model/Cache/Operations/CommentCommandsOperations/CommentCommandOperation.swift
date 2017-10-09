//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CommentCommandOperation: OutgoingCommandOperation {
    let command: CommentCommand
    let likesService: LikesServiceProtocol
    
    init(command: CommentCommand, likesService: LikesServiceProtocol) {
        self.command = command
        self.likesService = likesService
        super.init()
    }
    
}
