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
        
        guard let image = imageCache.image(for: command.photo), let commentHandle = command.relatedHandle else {
            completeOperation()
            return
        }
        
        imagesService.uploadCommentImage(image, commentHandle: commentHandle) { [weak self] result in
            guard let strongSelf = self, !strongSelf.isCancelled else {
                return
            }
            
            guard let imageHandle = result.value, let commentHandle = strongSelf.command.relatedHandle else {
                strongSelf.completeOperation(with: result.error)
                return
            }
            
            let predicate = strongSelf.predicateBuilder.createCommentCommand(commentHandle: commentHandle)
            
            let command = strongSelf.cache.firstOutgoing(ofType: OutgoingCommand.self,
                                                         predicate: predicate,
                                                         sortDescriptors: [Cache.createdAtSortDescriptor])
            
            guard let createCommentCommand = command as? CreateCommentCommand else {
                strongSelf.completeOperation(with: result.error)
                return
            }
            
            createCommentCommand.setImageHandle(imageHandle)
            
            strongSelf.cache.cacheOutgoing(createCommentCommand)
            
            strongSelf.completeOperation(with: result.error)
        }
    }
}
