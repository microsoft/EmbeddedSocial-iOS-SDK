//
//  CreatePostCreatePostInteractor.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class CreatePostInteractor: CreatePostInteractorInput {
    
    weak var output: CreatePostInteractorOutput!
    
    func postTopic(image: UIImage?, title: String?, body: String!) {
        let request = PostTopicRequest()
        request.title = title
        request.text = body
        TopicsAPI.topicsPostTopic(request: request) { (response, error) in
            guard let response = response else {
                guard let error = error else {
                    return
                }
                self.output.postCreationFailed(error: error)
                return
            }
        
            self.output.created(post: response)
        }
        
    }
}
