//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol RequestExecutionStrategy {
    associatedtype ResponseType
    associatedtype ResultType

    func execute(with builder: RequestBuilder<ResponseType>, completion: @escaping (Result<ResultType>) -> Void)
}
