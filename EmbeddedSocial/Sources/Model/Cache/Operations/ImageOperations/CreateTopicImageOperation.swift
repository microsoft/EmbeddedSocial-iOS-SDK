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
        
        guard let image = imageCache.image(for: command.photo), let topicHandle = command.relatedHandle else {
            completeOperation()
            return
        }
        
        imagesService.uploadTopicImage(image, topicHandle: topicHandle) { [weak self] result in
            guard let strongSelf = self, !strongSelf.isCancelled else {
                return
            }
            
            guard let imageHandle = result.value, let topicHandle = strongSelf.command.relatedHandle else {
                strongSelf.completeOperation(with: result.error)
                return
            }
            
            let predicate = strongSelf.predicateBuilder.createTopicCommand(topicHandle: topicHandle)
            
            let command = strongSelf.cache.firstOutgoing(ofType: OutgoingCommand.self,
                                                         predicate: predicate,
                                                         sortDescriptors: [Cache.createdAtSortDescriptor])
            
            guard let createTopicCommand = command as? CreateTopicCommand else {
                strongSelf.completeOperation(with: result.error)
                return
            }
            
            createTopicCommand.setImageHandle(imageHandle)
            
            strongSelf.cache.cacheOutgoing(createTopicCommand)
            
            strongSelf.completeOperation(with: result.error)
        }
    }
}
