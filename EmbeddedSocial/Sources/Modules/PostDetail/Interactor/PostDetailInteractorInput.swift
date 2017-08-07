//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PostDetailInteractorInput {
    func fetchComments(topicHandle: String)
    func postComment(image: UIImage?, topicHandle: String, comment: String)
    func likeComment(commentHandle: String)
    func unlikeComment(commentHandle: String)
}
