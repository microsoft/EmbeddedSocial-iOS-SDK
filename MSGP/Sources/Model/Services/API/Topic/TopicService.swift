//
//  TopicService.swift
//  MSGP
//
//  Created by Mac User on 24.07.17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import Alamofire

typealias SuccessClosure = (PostTopicRequest) -> Void
typealias ErrorClosure = (Error) -> Void

class TopicService {

    var success: SuccessClosure?
    var failure: ErrorClosure?
    
    func postTopic(topic: PostTopicRequest, image: Photo, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        self.success = success
        self.failure = failure
        guard let network = NetworkReachabilityManager() else {
            return
        }
        
        if network.isReachable {
            if let image = image.image {
                
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
                        return
                    }
                    DispatchQueue.main.async {
                        ImagesAPI.imagesPostImage(imageType: ImagesAPI.ImageType_imagesPostImage.contentBlob,
                                                  image: imageData) { (response, error) in
                                                    guard let blobHandle = response?.blobHandle else {
                                                        if let unwrappedError = error {
                                                            failure(unwrappedError)
                                                        }
                                                        return
                                                    }
                                                    topic.blobHandle = blobHandle
                                                    self.sendRequest(request: topic)
                    }
                }
                    
                }
            } else {
                sendRequest(request: topic)
            }
        } else {
//            let cacheModel = OutgoingTransaction(entity: OutgoingTransaction.entityName, insertInto: <#T##NSManagedObjectContext?#>)
        }
    }
    
    func sendRequest(request: PostTopicRequest) {
        TopicsAPI.topicsPostTopic(request: request) { [weak self] (response, error) in
            guard let response = response else {
                guard let error = error else {
                    return
                }
                
                self?.failure!(error)
                return
            }
            self?.success!(request)
//            self.output.created(post: response)
        }
    }
}
