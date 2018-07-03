//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol APIErrorHandler {
    func canHandle(_ error: Error?) -> Bool
    
    func handle(_ error: Error?)
}

extension APIErrorHandler {
    func handle<T>(error: ErrorResponse?, completion: @escaping (Result<T>) -> Void) {
        if canHandle(error) {
            handle(error)
        } else {
            completion(.failure(APIError(error: error)))
        }
    }
    
    func handle<T>(error: Error?, completion: @escaping (Result<T>) -> Void) {
        if canHandle(error) {
            handle(error)
        } else {
            completion(.failure(error ?? APIError.unknown))
        }
    }
}
