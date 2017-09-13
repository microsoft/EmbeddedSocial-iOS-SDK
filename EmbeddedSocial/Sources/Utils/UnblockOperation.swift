//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UnblockOperation: SocialActionOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        fatalError()
        /*socialService.unblock(userID: action.entityHandle) { [weak self] result in
            guard let strongSelf = self, !strongSelf.isCancelled else {
                return
            }
            strongSelf.completeOperation()
        }*/
    }
}
