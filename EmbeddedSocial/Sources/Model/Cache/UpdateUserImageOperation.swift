//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UpdateUserImageOperation: ImageCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        imagesService.updateUserPhoto(command.photo) { [weak self] result in
            self?.completeOperation(with: result.error)
        }
    }
}
