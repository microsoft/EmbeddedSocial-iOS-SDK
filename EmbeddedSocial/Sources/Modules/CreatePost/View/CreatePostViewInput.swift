//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CreatePostViewInput: class {

    func setupInitialState()
    func configTitlesForExistingPost()
    func configTitlesWithoutPost()
    func show(error: Error)
    func show(user: User)
    func show(post: Post)
    func topicCreated()
    func topicUpdated()
}
