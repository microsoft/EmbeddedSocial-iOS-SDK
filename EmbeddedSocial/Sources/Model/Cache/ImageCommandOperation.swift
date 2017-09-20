//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ImageCommandOperation: OutgoingCommandOperation {
    let command: ImageCommand
    let imagesService: ImagesServiceType
    
    init(command: ImageCommand, imagesService: ImagesServiceType) {
        self.command = command
        self.imagesService = imagesService
        super.init()
    }
}
