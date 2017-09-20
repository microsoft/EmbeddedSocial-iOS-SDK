//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class BlockOperation: UserCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        socialService.block(user: command.user) { [weak self] _ in
            self?.completeIfNotCancelled()
        }
    }
}
