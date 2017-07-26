//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CreatePostInteractor: CreatePostInteractorInput {
    
    weak var output: CreatePostInteractorOutput!
    var topicService: TopicService?
    
    func postTopic(photo: Photo?, title: String?, body: String!) {
        let topic = PostTopicRequest()
        topic.title = title
        topic.text = body
        
        topicService?.postTopic(topic: topic, photo: photo, success: { (_) in
            self.output.created()
        }, failure: { (error) in
            self.output.postCreationFailed(error: error)
        })
    }
}
