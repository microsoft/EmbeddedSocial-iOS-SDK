//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class TopicCommandOperation: AsyncOperation {
    let command: TopicCommand
    let likesService: LikesServiceProtocol
    
    init(command: TopicCommand, likesService: LikesServiceProtocol) {
        self.command = command
        self.likesService = likesService
        super.init()
    }
}
