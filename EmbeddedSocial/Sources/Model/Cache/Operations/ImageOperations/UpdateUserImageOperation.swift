//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UpdateUserImageOperation: ImageCommandOperation {
    
    private let userHolder: UserHolder
    
    init(command: ImageCommand,
         imagesService: ImagesServiceType,
         userHolder: UserHolder = SocialPlus.shared,
         predicateBuilder: OutgoingCommandsPredicateBuilder.Type = PredicateBuilder.self,
         cache: CacheType = SocialPlus.shared.cache) {
        
        self.userHolder = userHolder
        super.init(command: command, imagesService: imagesService, predicateBuilder: predicateBuilder, cache: cache)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        imagesService.updateUserPhoto(command.photo) { [weak self] result in
            guard let strongSelf = self, !strongSelf.isCancelled else {
                return
            }
            
            guard let photo = result.value else {
                strongSelf.completeOperation(with: result.error)
                return
            }
            
            strongSelf.userHolder.me?.photo = photo
            
            strongSelf.completeOperation(with: result.error)
        }
    }
}
