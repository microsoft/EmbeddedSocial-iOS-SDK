//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CancelPendingUserOperation: UserCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        socialService.cancelPending(user: command.user) { [weak self] result in
            self?.completeOperation(with: result.error)
        }
    }
}
