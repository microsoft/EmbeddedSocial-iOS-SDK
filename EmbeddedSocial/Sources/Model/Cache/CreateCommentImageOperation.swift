//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateCommentImageOperation: ImageCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        guard let image = command.photo.image, let commentHandle = command.relatedHandle else {
            completeIfNotCancelled()
            return
        }
        
        imagesService.uploadCommentImage(image, commentHandle: commentHandle) { [weak self] _ in
            self?.completeIfNotCancelled()
        }
    }
}
