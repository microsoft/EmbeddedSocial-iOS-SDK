//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateTopicImageOperation: ImageCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        guard let image = command.photo.image, let topicHandle = command.relatedHandle else {
            completeIfNotCancelled()
            return
        }
        
        imagesService.uploadTopicImage(image, topicHandle: topicHandle) { [weak self] _ in
            self?.completeIfNotCancelled()
        }
    }
}
