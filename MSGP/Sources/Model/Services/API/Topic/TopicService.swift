//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//
import Foundation
import Alamofire

typealias TopicPosted = (PostTopicRequest) -> Void
typealias Failure = (Error) -> Void

class TopicService {
    
    private var success: TopicPosted?
    private var failure: Failure?
    
    var cache: Cachable?
    
    func postTopic(topic: PostTopicRequest, photo: Photo?, success: @escaping TopicPosted, failure: @escaping Failure) {
        self.success = success
        self.failure = failure
        
        guard let network = NetworkReachabilityManager() else {
            return
        }
        
        if network.isReachable {
            if let image = photo?.image {
                
                guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
                    return
                }
                
                ImagesAPI.imagesPostImage(imageType: ImagesAPI.ImageType_imagesPostImage.contentBlob,
                                          image: imageData) { [weak self] (response, error) in
                                            guard let blobHandle = response?.blobHandle else {
                                                if let unwrappedError = error {
                                                    failure(unwrappedError)
                                                }
                                                return
                                            }
                                            
                                            topic.blobHandle = blobHandle
                                            self?.sendPostTopicRequest(request: topic)
                }
            } else {
                sendPostTopicRequest(request: topic)
            }
        } else {
            
            if photo != nil {
                cache?.cacheOutgoing(object: photo!)
                topic.blobHandle = photo?.url
            }
            
            cache?.cacheOutgoing(object: topic)
        }
    }
    
    private func sendPostTopicRequest(request: PostTopicRequest) {
        TopicsAPI.topicsPostTopic(request: request) { [weak self] (response, error) in
            guard let response = response else {
                self?.failure!(error!)
                return
            }
            
            print(response.topicHandle!)
            self?.cache?.cacheIncoming(object: request)
            self?.success!(request)
        }
    }
}
