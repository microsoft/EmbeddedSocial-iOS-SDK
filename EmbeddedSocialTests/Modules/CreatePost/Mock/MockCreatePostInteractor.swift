//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCreatePostInteractor: CreatePostInteractor {
    private(set) var photo: Photo!
    private(set) var title: String!
    private(set) var body: String!
    
    private(set) var postTopicCalledCount = 0
    
    override func postTopic(photo: Photo?, title: String?, body: String!) {
        super.postTopic(photo: photo, title: title, body: body)
        self.photo = photo
        self.title = title
        self.body = body
        postTopicCalledCount += 1
    }
    
    
}
