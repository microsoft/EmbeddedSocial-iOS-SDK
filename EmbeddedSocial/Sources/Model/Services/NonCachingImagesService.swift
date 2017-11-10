//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class NonCachingImagesService: ImagesService {
    
    override func cacheCommandAndComplete(_ command: ImageCommand, completion: @escaping (Result<String>) -> Void) {
    
    }
    
    override func onImageDataUploadSuccess(newHandle: String, completion: @escaping (Result<String>) -> Void) {
        completion(.success(newHandle))
    }

}
