//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CommentCellViewOutput {
    func viewIsReady()
    func like()
    func toReplies(scrollType: RepliesScrollType)
    func avatarPressed()
    func mediaPressed()
    func likesPressed()
}
