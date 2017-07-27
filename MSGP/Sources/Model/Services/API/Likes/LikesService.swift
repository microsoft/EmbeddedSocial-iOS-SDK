//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol LikesService {
    
    func postLike(postHandle: String, completion: @escaping () -> Void)
    
}

class LikesService:



//open class func topicLikesPostLike(topicHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
//    topicLikesPostLikeWithRequestBuilder(topicHandle: topicHandle).execute { (response, error) -> Void in
//        completion(response?.body, error);
//    }
//}
