//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class PinTopicOperation: TopicCommandOperation {
    
    private let likesService: LikesServiceProtocol
    
    init(command: TopicCommand, likesService: LikesServiceProtocol) {
        self.likesService = likesService
        super.init(command: command)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        likesService.postPin(post: command.topic) { [weak self] _, error in
            self?.completeOperation(with: error)
        }
    }
}
