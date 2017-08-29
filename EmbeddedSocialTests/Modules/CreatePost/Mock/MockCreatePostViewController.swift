//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCreatePostViewController: CreatePostViewInput {
    private(set) var errorShowedCount = 0
    private(set) var userShowedCount = 0
    
    var output: CreatePostViewOutput!
    
    func show(error: Error) {
        errorShowedCount += 1
    }
    
    func show(user: User) {
        userShowedCount += 1
    }
    
    var topicUpdatedCount = 0
    func topicUpdated() {
        topicUpdatedCount += 1
    }
    
    var topicCreatedCount = 0
    func topicCreated() {
        topicCreatedCount += 1
    }
    
    var configTitlesWithoutPostCount = 0
    func configTitlesWithoutPost() {
        configTitlesWithoutPostCount += 1
    }
    
    var configTitlesForExistingPostCount = 0
    func configTitlesForExistingPost() {
        configTitlesForExistingPostCount += 1
    }
    
    var showPostCount = 0
    func show(post: Post) {
        showPostCount += 1
    }
    
    func setupInitialState() {
        
    }
}
