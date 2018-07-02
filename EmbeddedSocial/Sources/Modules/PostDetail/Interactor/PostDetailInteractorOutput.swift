//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PostDetailInteractorOutput: class {
    func didFetch(comments: [Comment], cursor: String?)
    func didFetchMore(comments: [Comment], cursor: String?)
    func didFail(error: Error)
    func commentDidPost(comment: Comment)
    func commentPostFailed(error: Error)
}
