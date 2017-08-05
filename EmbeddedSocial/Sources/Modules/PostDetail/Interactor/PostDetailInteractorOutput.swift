//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PostDetailInteractorOutput: class {
    func didFetch(comments: [Comment])
    func didFetchMore(comments: [Comment])
    func didFail(error: CommentsServiceError)
}
