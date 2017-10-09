//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ResponseProcessor<ResponseType, ResultType> {
    func process(_ response: ResponseType?, isFromCache: Bool, completion: @escaping (Result<ResultType>) -> Void) {
        fatalError("Override in subclass")
    }
}
