//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CreatePostInteractor: CreatePostInteractorInput {
    
    weak var output: CreatePostInteractorOutput!
    var topicService: PostServiceProtocol?
    private let userHolder: UserHolder
    
    init(userHolder: UserHolder = SocialPlus.shared) {
        self.userHolder = userHolder
    }
    
    func postTopic(photo: Photo?, title: String?, body: String!) {
        let uid = UUID().uuidString
        
        guard let user = userHolder.me else {
            fatalError("Cant create topic with no user")
        }
            
        let post = Post(topicHandle: uid,
             createdTime: nil,
             user: user,
             imageUrl: photo?.url,
             imageHandle: photo?.uid,
             title: title,
             text: body,
             deepLink: nil,
             totalLikes: 0,
             totalComments: 0,
             liked: false,
             pinned: false)
        
        topicService?.postTopic(post,
                                photo: photo,
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
