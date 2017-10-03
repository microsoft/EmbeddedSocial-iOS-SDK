//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCreatePostInteractor: CreatePostInteractorInput {
    private(set) var photo: Photo!
    private(set) var title: String!
    private(set) var body: String!
    
    private(set) var postTopicCalledCount = 0
    
    weak var output: CreatePostInteractorOutput!
    
    func postTopic(photo: Photo?, title: String?, body: String!) {
        self.photo = photo
        self.title = title
        self.body = body
        postTopicCalledCount += 1
        output.created()
    }
    
    var updateTopicCount = 0
    func updateTopic(topicHandle: String, title: String?, body: String) {
        updateTopicCount += 1
        output.postUpdated()
    }
    
    
}
