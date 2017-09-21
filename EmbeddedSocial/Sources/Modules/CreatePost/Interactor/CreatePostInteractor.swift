//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CreatePostInteractor: CreatePostInteractorInput {
    
    weak var output: CreatePostInteractorOutput!
    var topicService: TopicService?
    private let userHolder: UserHolder
    
    init(userHolder: UserHolder = SocialPlus.shared) {
        self.userHolder = userHolder
    }
    
    func postTopic(photo: Photo?, title: String?, body: String!) {
        var topic = Post(topicHandle: UUID().uuidString)
        topic.title = title
        topic.text = body
        topic.photo = photo
        topic.user = userHolder.me
        
        topicService?.postTopic(topic,
                                success: { [weak self] _ in self?.output.created() },
                                failure: { [weak self] error in self?.output.postCreationFailed(error: error) })
    }
    
    func updateTopic(topicHandle: String, title: String?, body: String) {
        let topic = PutTopicRequest()
        topic.title = title
        topic.text = body
        
        topicService?.updateTopic(topicHandle: topicHandle, request: topic, success: { (object) in
            self.output.postUpdated()
        }, failure: { (error) in
            self.output.postUpdateFailed(error: error)
        })
    }
}
