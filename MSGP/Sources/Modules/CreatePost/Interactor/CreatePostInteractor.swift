//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CreatePostInteractor: CreatePostInteractorInput {
    
    weak var output: CreatePostInteractorOutput!
    
    func postTopic(image: UIImage?, title: String?, body: String!) {
        let request = PostTopicRequest()
        request.title = title
        request.text = body
        
        if let image = image {
            guard let imageData = UIImagePNGRepresentation(image) as Data? else {
                return
            }
            
            ImagesAPI.imagesPostImage(imageType: ImagesAPI.ImageType_imagesPostImage.contentBlob,
                                      image: imageData) { (response, error) in
                                        guard let blobHandle = response?.blobHandle else {
                                            if let unwrappedError = error {
                                                self.output.postCreationFailed(error: unwrappedError)
                                            }
                                            return
                                        }
                                        request.blobHandle = blobHandle
                                        self.sendRequest(request: request)
               
            }
        } else {
            sendRequest(request: request)
        }
        
    }
    
    func sendRequest(request: PostTopicRequest) {
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
