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
            completeOperation()
            return
        }
        
        imagesService.uploadCommentImage(image, commentHandle: commentHandle) { [weak self] result in
            self?.completeOperation(with: result.error)
        }
    }
}
